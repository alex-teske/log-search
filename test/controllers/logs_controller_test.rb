require "test_helper"

class LogsControllerTest < ActionDispatch::IntegrationTest
  test 'log search endpoint should successfully return json' do
    get '/logs/search'
    assert_equal 'application/json; charset=utf-8', response.content_type
  end
end
