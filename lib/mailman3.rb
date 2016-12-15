require "json"
require "httparty"

require "mailman3/version"

module Mailman3
  autoload :Base, "mailman3/base"
  autoload :Domain, "mailman3/domain"

  class << self
    attr_accessor :base_url, :user, :password
  end

  def self.configure
    yield self
  end
end
