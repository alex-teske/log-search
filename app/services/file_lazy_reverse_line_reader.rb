class FileLazyReverseLineReader
  include ApplicationService

  DEFAULT_CHUNK_SIZE = 512

  def initialize(file, chunk_size = DEFAULT_CHUNK_SIZE)
    @file = file
    @chunk_size = chunk_size
  end

  def call
    # Jump to the end of the file
    @file.seek(0, IO::SEEK_END)
    file_size = @file.pos

    @max_read_size = [@chunk_size, file_size].min
    @file_pos = file_size - @max_read_size
    @prev_pos = file_size
    @line_buffer = ''

    reverse_each_line.lazy
  end

  private

  def reverse_each_line(&block)
    return enum_for(:reverse_each_line) unless block_given?

    loop do
      # Handle edge case of reading last chunk
      chunk_size = [@max_read_size, @prev_pos].min

      chunk = read_chunk(chunk_size)
      process_chunk(chunk, &block)

      break if @file_pos.zero?

      @prev_pos = @file_pos
      @file_pos = [@file_pos - chunk_size, 0].max
    end

    yield @line_buffer unless @line_buffer.empty?
  end

  def read_chunk(chunk_size)
    @file.seek(@file_pos, IO::SEEK_SET)
    @file.read(chunk_size)
  end

  def process_chunk(chunk)
    # Split on newline characters
    split_chunk = chunk.split(/[\r\n]+/, -1)
    return if split_chunk.empty?

    # The last element is a continuation of the previous line
    # (This removes the last element from split_chunk)
    @line_buffer = split_chunk.pop + @line_buffer

    # This chunk contained no newline characters
    return if split_chunk.empty?

    # There's at least one space in the chunk, clear the buffer
    yield @line_buffer unless @line_buffer.empty?
    @line_buffer = ''

    # The first element is an incomplete line
    # (This removes the first element from split_chunk)
    @line_buffer = split_chunk.shift

    # Process remaining complete lines (if any remain)
    split_chunk.reverse_each do |line|
      yield line unless line.empty?
    end
  end
end
