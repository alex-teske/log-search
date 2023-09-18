class FileLazyReverseLineReaderTest < ActiveSupport::TestCase
  test 'should correctly process an empty file' do
    file = test_file('empty.txt')

    expected = []
    result = FileLazyReverseLineReader.call(file).to_a
    assert_equal(expected, result)
  end

  test 'should correctly process a file with only one line' do
    file = test_file('single_log.txt')

    expected = ["only one log message here"]
    result = FileLazyReverseLineReader.call(file).to_a
    assert_equal(expected, result)
  end

  [1, 2, 3, 4, 8, 256, 512, 1024].each do |chunk_size|
    test "should correctly process file when chunk size is #{chunk_size}" do
      file = test_file('small_log.txt')

      expected = ['newest log message', 'kinda new log message', 'kinda old log message', 'oldest log message']
      result = FileLazyReverseLineReader.call(file, chunk_size).to_a
      assert_equal(expected, result)
    end
  end

  private

  def test_file(name)
    path = Rails.root.join('test', 'fixtures', 'files', name)
    File.open(path, 'r')
  end
end
