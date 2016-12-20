require "json"
require "httparty"

require "mailman3/version"

module Mailman3
  autoload :APIError, "mailman3/api_error"
  autoload :Base, "mailman3/base"
  autoload :Domain, "mailman3/domain"
  autoload :List, "mailman3/list"
  autoload :Member, "mailman3/member"

  class << self
    attr_accessor :base_url, :user, :password
  end

  def self.configure
    yield self
  end
end
