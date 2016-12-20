module Mailman3

  # Base class for all API Wrapper classes. Contains shared configuration and
  # methods.
  class Base
    include HTTParty

    base_uri "#{Mailman3.base_url}/3.0"
    basic_auth Mailman3.user, Mailman3.password

    [:get, :post, :patch, :put].each do |method|
      define_singleton_method method do |*args|
        response = super(*args)
        if response.code >= 400
          raise APIError, response.body
        end
        response
      end
    end

    def initialize(attributes = {})
      attributes.each do |key, value|
        setter = :"#{key}="
        if respond_to? setter
          send(setter, value)
        end
      end
    end
  end
end
