require 'minitest/autorun'

class LogSearcherTest < ActiveSupport::TestCase

  def setup
    @valid_search_params = LogSearcherParameters.new(
      file_name: 'test2.log'
    )

    @invalid_search_params = LogSearcherParameters.new(
      file_name: '' # Invalid file name
    )
  end

  test 'should return results when passing valid search parameters' do
    mock_file_content do
      result = LogSearcher.call(@valid_search_params)

      expected = ['newest log message', 'kinda new log message', 'kinda old log message', 'oldest log message']
      assert_equal(expected, result.value)
    end
  end

  test 'should filter results by keyword search' do
    mock_file_content do
      @valid_search_params.search_string = 'kinda'
      result = LogSearcher.call(@valid_search_params)

      expected = ['kinda new log message', 'kinda old log message']
      assert_equal(expected, result.value)
    end
  end

  test 'should limit results' do
    mock_file_content do
      @valid_search_params.limit = 2
      result = LogSearcher.call(@valid_search_params)

      expected = ['newest log message', 'kinda new log message']
      assert_equal(expected, result.value)
    end
  end

  test 'should paginate results' do
    mock_file_content do
      @valid_search_params.limit = 2
      @valid_search_params.page = 2
      result = LogSearcher.call(@valid_search_params)

      expected = ['kinda old log message', 'oldest log message']
      assert_equal(expected, result.value)
    end
  end

  test 'should return an error when passing invalid search parameters' do
    result = LogSearcher.call(@invalid_search_params)

    assert_equal :bad_request, result.status_code
    assert_includes result.error, "File name can't be blank"
  end

  test 'should return an error when file not found' do
    mock_open_file_error(Errno::ENOENT) do
      result = LogSearcher.call(@valid_search_params)

      assert(result.failure?)
      assert_equal(:not_found, result.status_code)
      assert_equal('File not found', result.error)
    end
  end

  test 'should return an error when permission is denied' do
    mock_open_file_error(Errno::EACCES) do
      result = LogSearcher.call(@valid_search_params)

      assert(result.failure?)
      assert_equal(:forbidden, result.status_code)
      assert_equal('Permission denied', result.error)
    end
  end

  test 'should return an error when internal error' do
    mock_open_file_error('oopsie') do
      result = LogSearcher.call(@valid_search_params)

      assert(result.failure?)
      assert_equal(:internal_server_error, result.status_code)
      assert_equal('oopsie', result.error)
    end
  end

  private

  def mock_open_file_error(error, &block)
    File.stub(:open, proc { raise error }) do
      block.call
    end
  end

  def mock_file_content(&block)
    path = Rails.root.join('test', 'fixtures', 'files', 'small_log.txt')
    @file = File.open(path, 'r')

    File.stub(:open, ->(_, _, &block) { block.call(@file) }) do
      block.call
    end
  end
end
