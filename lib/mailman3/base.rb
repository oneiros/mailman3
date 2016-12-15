module Mailman3

  # Base class for all API Wrapper classes. Contains shared configuration and
  # methods.
  class Base
    include HTTParty

    base_uri "#{Mailman3.base_url}/3.0"
    basic_auth Mailman3.user, Mailman3.password

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
