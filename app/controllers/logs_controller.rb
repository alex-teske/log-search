class LogsController < ApplicationController
  def show
    unless search_params.valid?
      render json: { error: search_params.errors.full_messages.join(',') }, status: :bad_request
      return
    end

    log_file_path = File.join('/var/logs', search_params.file_name)
    regex = /#{Regexp.quote(search_params.search_string)}/

    results = File.open(log_file_path, 'r') do |log_file|
      log_file
        .reverse_each
        .lazy
        .grep(regex)
        .take(search_params.limit)
        .map(&:strip)
        .to_a
    end

    render json: { file_name: search_params.file_name, entries: results }
  rescue Errno::ENOENT
    render json: { error: 'File not found' }, status: :not_found
  rescue Errno::EACCES
    render json: { error: 'Permission denied' }, status: :forbidden
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def permitted_params
    @permitted_params ||= params.permit(:file_name, :limit, :search_string)
  end

  def search_params
    @search_params ||= LogSearcherParameters.new(permitted_params)
  end
end
