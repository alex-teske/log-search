class LogSearcherParametersTest < ActiveSupport::TestCase
  def setup
    @search_params = LogSearcherParameters.new(
      file_name: 'test2.log',
      search_string: 'hey',
      limit: 5
    )
  end

  test 'initialize LogSearcherParameters with valid options' do
    assert_instance_of LogSearcherParameters, @search_params
    assert @search_params.valid?
    assert_equal 'test2.log', @search_params.file_name
    assert_equal 5, @search_params.limit
    assert_equal 'hey', @search_params.search_string
  end

  test 'parameters are invalid if file_name is missing' do
    @search_params.file_name = ''

    refute @search_params.valid?
    assert_includes @search_params.errors.full_messages, "File name can't be blank"
  end

  test 'parameters are invalid if search_string is too long' do
    @search_params.search_string = 'a' * 256

    refute @search_params.valid?
    assert_includes @search_params.errors.full_messages, 'Search string is too long (maximum is 255 characters)'
  end

  test 'parameters are invalid if limit not greater than zero ' do
    @search_params.limit = 0

    refute @search_params.valid?
    assert_includes @search_params.errors.full_messages, 'Limit must be greater than 0'
  end

  test 'parameters are invalid if limit is too large' do
    @search_params.limit = 1000

    refute @search_params.valid?
    assert_includes @search_params.errors.full_messages, 'Limit must be less than 1000'
  end

  test 'parameters are invalid if page not greater than zero' do
    @search_params.page = 0

    refute @search_params.valid?
    assert_includes @search_params.errors.full_messages, 'Page must be greater than 0'
  end

  test 'parameters are invalid if page is not a number' do
    @search_params.page = 'abc'

    refute @search_params.valid?
    assert_includes @search_params.errors.full_messages, 'Page is not a number'
  end
end
