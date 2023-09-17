class LogSearcherParameters
  include ActiveModel::Validations

  attr_accessor :file_name, :limit, :search_string

  validates_presence_of :file_name
  validates_length_of :search_string, minimum: 0, maximum: 255
  validates :limit, numericality: { greater_than: 0, less_than: 1000 }

  def initialize(attributes = {})
    @file_name = attributes[:file_name]
    @limit = attributes.key?(:limit) ? attributes[:limit].to_i : 10
    @search_string = attributes[:search_string] || ''
  end
end
