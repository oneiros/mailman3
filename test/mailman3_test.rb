require 'test_helper'

class Mailman3Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mailman3::VERSION
  end

  def test_configuration
    Mailman3.configure do |config|
      config.base_url = "http://localhost:8001"
      config.user = "mymailman"
      config.password = "mailmanpw"
    end

    assert_equal "http://localhost:8001", Mailman3.base_url
    assert_equal "mymailman", Mailman3.user
    assert_equal "mailmanpw", Mailman3.password

    # clean up
    Mailman3.configure do |config|
      config.base_url = "http://localhost:9001"
      config.user = "mailman"
      config.password = "mmtestpw"
    end
  end
end
