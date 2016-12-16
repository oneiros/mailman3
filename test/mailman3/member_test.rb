require "test_helper"

module Mailman3
  class MemberTest < Minitest::Test

    def test_it_allows_querying_for_existing_members
      stub_mailman(:get, "/members", 'members/all')

      result = Member.all
      assert_instance_of Array, result
      assert_equal 3, result.size
      assert_equal 'aperson@example.com', result.first.email
      assert_equal 'bee.example.com', result.first.list_id
      assert_equal 'member', result.last.role
    end

    def test_it_allows_querying_for_existing_members_of_a_list
      stub_mailman(:get, "/members/find?list_id=bee.example.com", 'members/all')

      result = Member.all('bee.example.com')
      assert_instance_of Array, result
      assert_equal 'aperson@example.com', result.first.email
      assert_equal 'bee.example.com', result.first.list_id
      assert_equal 'member', result.last.role
    end

    def test_it_allows_getting_information_for_a_specific_member
      stub_mailman(:get, "/lists/bee.example.com/member/aperson@example.com", 'members/find_member')

      result = Member.find('bee.example.com', 'aperson@example.com')
      assert_instance_of Member, result
      assert_equal "aperson@example.com", result.email
      assert_equal "member", result.role
      assert_equal 3, result.member_id
    end

    def test_it_allows_getting_information_for_a_specific_owner
      stub_mailman(:get, "/lists/bee.example.com/owner/cperson@example.com", 'members/find_owner')

      result = Member.find('bee.example.com', 'cperson@example.com', 'owner')
      assert_instance_of Member, result
      assert_equal "cperson@example.com", result.email
      assert_equal "owner", result.role
      assert_equal 7, result.member_id
    end

    def test_it_allows_creating_new_memberships
      stub_mailman(:post, "/members", 'members/create', {list_id: 'bee.example.com', subscriber: 'aperson@example.com'})

      result = Member.create(list_id: 'bee.example.com', subscriber: 'aperson@example.com')
      assert_equal true, result
    end

    def test_creating_members_that_need_to_confirm_returns_confirmation_token
      stub_mailman(:post, "/members", 'members/create_pending_confirmation', {list_id: 'bee.example.com', subscriber: 'aperson@example.com'})

      result = Member.create(list_id: 'bee.example.com', subscriber: 'aperson@example.com')
      assert_equal 'abcdefghijkl', result
    end

    def test_creating_without_list_id_raises_error
      assert_raises ArgumentError do
        Member.create(subscriber: 'aperson@example.com')
      end
    end

    def test_creating_without_subscriber_raises_error
      assert_raises ArgumentError do
        Member.create(list_id: 'ant.example.com')
      end
    end

    def test_it_allows_deleting_existing_members
      stub_mailman(:get, "/lists/bee.example.com/member/aperson@example.com", 'members/find_member')
      stub_mailman(:delete, "/members/3", 'members/delete')

      result = Member.destroy('bee.example.com', 'aperson@example.com')
      assert_equal true, result
    end

    def test_it_allows_deleting_existing_owners
      stub_mailman(:get, "/lists/bee.example.com/owner/cperson@example.com", 'members/find_owner')
      stub_mailman(:delete, "/members/7", 'members/delete')

      result = Member.destroy('bee.example.com', 'cperson@example.com', 'owner')
      assert_equal true, result
    end
  end
end
