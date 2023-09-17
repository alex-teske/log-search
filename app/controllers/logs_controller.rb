class LogsController < ApplicationController
  # For web requests
  def show
    if search_result.success?
      result = { file_name: search_params.file_name, entries: search_result.value }
    else
      error = { message: search_result.error, status: search_result.status_code }
    end

    render :show, locals: {
      default_file_name: search_params.file_name || '',
      default_search_string: search_params.search_string || '',
      default_limit: search_params.limit || 10,
      default_page: search_params.page || 1,
      result:,
      error:
    }
  end

  # For API Requests
  def show_api
    if search_result.success?
      render json: { file_name: search_params.file_name, entries: search_result.value }
    else
      render json: { error: search_result.error }, status: search_result.status_code
    end
  end

  private

  def permitted_params
    @permitted_params ||= params.permit(:file_name, :search_string, :limit, :page, :commit)
  end

  def search_params
    @search_params ||= LogSearcherParameters.new(permitted_params)
  end

  def search_result
    @search_result ||= LogSearcher.call(search_params)
  end
end
