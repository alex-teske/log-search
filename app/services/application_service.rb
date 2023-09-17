module ApplicationService
  extend ActiveSupport::Concern

  included do
    private_class_method :new
  end

  class_methods do
    def call(...)
      new(...).call
    end
  end
end
