require "test_helper"

module Mailman3
  class ListTest < Minitest::Test

    def test_it_allows_querying_for_existing_lists
      stub_mailman(:get, "/lists", 'lists/all')

      result = List.all
      assert_instance_of Array, result
      assert_equal 1, result.size
      assert_equal 'Ant', result.first.display_name
      assert_equal 'ant@example.com', result.first.fqdn_listname
    end

    def test_it_allows_querying_for_existing_lists_from_a_domain
      stub_mailman(:get, "/domains/example.com/lists", 'lists/all')

      result = List.all('example.com')
      assert_instance_of Array, result
      assert_equal 1, result.size
      assert_equal 'Ant', result.first.display_name
      assert_equal 'ant@example.com', result.first.fqdn_listname
    end

    def test_it_allows_getting_information_for_a_specific_list
      stub_mailman(:get, "/lists/bee.example.com", 'lists/find')

      result = List.find('bee.example.com')
      assert_instance_of List, result
      assert_equal "Bee", result.display_name
      assert_equal "bee@example.com", result.fqdn_listname
    end

    def test_it_allows_creating_new_lists
      stub_mailman(:post, "/lists", 'lists/create', {fqdn_listname: 'bee@example.com'})
      stub_mailman(:get, "/lists/bee.example.com", 'lists/find')

      result = List.create(fqdn_listname: 'bee@example.com')
      assert_instance_of List, result
      assert_equal "bee@example.com", result.fqdn_listname
    end

    def test_creating_without_fqdn_listname_raises_error
      assert_raises ArgumentError do
        List.create({})
      end
    end

    def test_it_allows_deleting_existing_lists
      stub_mailman(:delete, "/lists/bee.example.com", 'lists/delete')

      result = List.destroy('bee.example.com')
      assert_equal true, result
    end

    def test_it_allows_reading_the_list_config
      stub_mailman(:get, "/lists/ant.example.com/config", 'lists/config')

      list = List.new(list_id: 'ant.example.com', fqdn_listname: 'ant@example.com')
      config = list.config
      assert_equal false, config[:anonymous_list]
      assert_equal "noreply@example.com", config[:no_reply_address]
      assert_equal 1, config[:volume]
    end

    def test_it_allows_setting_config_values
      stub_mailman(:patch, "/lists/ant.example.com/config", 'lists/update_config', {
        display_name: 'Super Ant', description: 'Ant list'
      })

      list = List.new(list_id: 'ant.example.com', fqdn_listname: 'ant@example.com')
      result = list.update_config({
        display_name: 'Super Ant',
        description: 'Ant list'
      })
      assert_equal true, result
    end

    def test_it_allows_getting_all_members
      list = List.new(list_id: 'ant.example.com')
      Member.stub :all, [1, 2, 3] do
        assert_equal [1, 2, 3], list.members
      end
    end

    def test_it_allows_adding_members
      list = List.new(list_id: 'ant.example.com')
      Member.stub :create, true do
        assert_equal true, list.subscribe("bperson@example.com")
      end
    end

    def test_it_allows_adding_owners
      list = List.new(list_id: 'ant.example.com')
      Member.stub :create, true do
        assert_equal true, list.add_owner("cperson@example.com")
      end
    end

    def test_it_allows_removing_members
      list = List.new(list_id: 'ant.example.com')
      Member.stub :destroy, true do
        assert_equal true, list.unsubscribe("bperson@example.com")
      end
    end

    def test_it_allows_removing_owners
      list = List.new(list_id: 'ant.example.com')
      Member.stub :destroy, true do
        assert_equal true, list.remove_owner("cperson@example.com")
      end
    end
  end
end
