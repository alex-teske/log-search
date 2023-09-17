class LogsController < ApplicationController
  def show
    if search_result.success?
      render json: { file_name: search_params.file_name, entries: search_result.value }
    else
      render json: { error: search_result.error }, status: search_result.status_code
    end
  end

  private

  def permitted_params
    @permitted_params ||= params.permit(:file_name, :search_string, :limit, :page)
  end

  def search_params
    @search_params ||= LogSearcherParameters.new(permitted_params)
  end

  def search_result
    @search_result ||= LogSearcher.call(search_params)
  end
end
