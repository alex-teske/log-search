class LogSearcherParameters
  include ActiveModel::Validations

  attr_accessor :file_name, :search_string, :limit, :page

  validates_presence_of :file_name
  validates_length_of :search_string, minimum: 0, maximum: 255
  validates :limit, numericality: { greater_than: 0, less_than: 1000 }
  validates :page, numericality: { greater_than: 0 }

  def initialize(attributes = {})
    @file_name = attributes[:file_name]
    @search_string = attributes[:search_string] || ''
    @limit = attributes.key?(:limit) ? attributes[:limit].to_i : 10
    @page = attributes.key?(:page) ? attributes[:page].to_i : 1
  end
end
