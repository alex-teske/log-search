class LogSearcher
  include ApplicationService

  def initialize(search_parameters)
    @search_params = search_parameters
  end

  def call
    return handle_invalid_search_parameters if @search_params.invalid?

    Result.new(search_log_file)
  rescue Errno::ENOENT
    Result.new(nil, 'File not found', :not_found)
  rescue Errno::EACCES
    Result.new(nil, 'Permission denied', :forbidden)
  rescue StandardError => e
    Result.new(nil, e.message, :internal_server_error)
  end

  private

  def search_log_file
    File.open(log_file_path, 'r') do |log_file|
      log_file
        .reverse_each
        .lazy
        .grep(search_regex)
        .drop(@search_params.limit * (@search_params.page - 1))
        .take(@search_params.limit)
        .map(&:strip)
        .to_a
    end
  end

  def log_file_path
    File.join('/var/logs', @search_params.file_name)
  end

  def search_regex
    /#{Regexp.quote(@search_params.search_string)}/
  end

  def handle_invalid_search_parameters
    Result.new(nil, @search_params.errors.full_messages.join(','), :bad_request)
  end
end
