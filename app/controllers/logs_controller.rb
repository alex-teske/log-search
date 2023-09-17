class LogsController < ApplicationController
  def show
    file_name = permitted_params[:file_name]
    search_string = permitted_params[:search_string]
    limit = permitted_params[:limit].to_i

    log_file_path = File.join('/var/logs', file_name)
    regex = /#{Regexp.quote(search_string)}/

    results = File.open(log_file_path, 'r') do |log_file|
      log_file
        .reverse_each
        .lazy
        .grep(regex)
        .take(limit)
        .map(&:strip)
        .to_a
    end

    render json: { file_name: file_name, entries: results }
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
end
