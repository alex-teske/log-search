require "test_helper"

class LogsControllerTest < ActionDispatch::IntegrationTest
  test 'log endpoint should successfully return html' do
    get '/logs'
    assert_response :success
    assert_equal 'text/html; charset=utf-8', response.content_type
  end

  test 'log search endpoint should successfully return json' do
    get '/logs/search'
    assert_equal 'application/json; charset=utf-8', response.content_type
  end
end
