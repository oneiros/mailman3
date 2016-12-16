require "test_helper"

module Mailman3
  class DomainTest < Minitest::Test

    def test_it_allows_querying_for_existing_domains
      stub_mailman(:get, "/domains", 'domains/all')

      result = Domain.all
      assert_instance_of Array, result
      assert_equal 3, result.size
      assert_equal 'An example domain', result.first.description
      assert_equal 'http://localhost:9001/3.0/domains/lists.example.net', result.last.self_link
    end

    def test_it_allows_getting_information_for_a_specific_domain
      stub_mailman(:get, "/domains/lists.example.net", 'domains/find')

      result = Domain.find('lists.example.net')
      assert_instance_of Domain, result
      assert_equal "Porkmasters", result.description
      assert_equal "lists.example.net", result.mail_host
    end

    def test_it_allows_creating_new_domains
      stub_mailman(:post, "/domains", 'domains/create', {mail_host: 'lists.example.net'})
      stub_mailman(:get, "/domains/lists.example.net", 'domains/find')

      result = Domain.create(mail_host: 'lists.example.net')
      assert_instance_of Domain, result
      assert_equal "Porkmasters", result.description
      assert_equal "lists.example.net", result.mail_host
    end

    def test_creating_without_mail_host_raises_error
      assert_raises ArgumentError do
        Domain.create({})
      end
    end

    def test_it_allows_deleting_existing_domains
      stub_mailman(:delete, "/domains/lists.example.com", 'domains/delete')

      result = Domain.destroy('lists.example.com')
      assert_equal true, result
    end

    def test_it_allows_getting_all_lists_for_a_domain
      domain = Domain.new(mail_host: 'lists.example.com')
      List.stub :all, [1,2,3] do
        assert_equal [1, 2, 3], domain.lists
      end
    end

    def test_it_allows_creating_a_list
      domain = Domain.new(mail_host: 'lists.example.com')
      List.stub :create, true do
        assert_equal true, domain.create_list(fqdn_listname: 'test@lists.example.com')
      end
    end
  end
end
