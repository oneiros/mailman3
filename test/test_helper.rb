$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mailman3'

require 'minitest/autorun'
require 'webmock/minitest'
require 'yaml'

WebMock.disable_net_connect!

Mailman3.configure do |config|
  config.base_url = "http://localhost:9001"
  config.user = "mailman"
  config.password = "mmtestpw"
end

module MailmanStubber
  def stub_mailman(method, path, yaml_path, body = nil)
    yaml = File.read("#{File.dirname(__FILE__)}/fixtures/#{yaml_path}.yml")
    response_hash = YAML.load yaml
    stub_request(method, "#{Mailman3.base_url}/3.0#{path}")
      .with(basic_auth: ['mailman', 'mmtestpw'], body: body)
      .to_return(
        headers: {content_type: 'application/json'},
        body: response_hash.to_json
      )
  end
end

Minitest::Test.include MailmanStubber
