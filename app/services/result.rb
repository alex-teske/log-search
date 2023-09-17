class Result
  attr_reader :value, :error, :status_code

  def initialize(value, error = nil, status_code = nil)
    @value = value
    @error = error
    @status_code = status_code
  end

  def success?
    @error.nil?
  end

  def failure?
    !success?
  end
end
