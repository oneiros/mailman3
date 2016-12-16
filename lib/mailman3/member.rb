module Mailman3
  class Member < Base

    attr_accessor :address, :delivery_mode, :email, :list_id, :member_id, :role, :self_link, :user

    def self.all(list_id = nil)
      path, query = if list_id.nil?
                      ['/members', nil]
                    else
                      ['/members/find', {list_id: list_id}]
                    end
      response = get(path, query: query).parsed_response
      response['entries'] ||= []
      response['entries'].map do |entry|
        new(entry)
      end
    end

    def self.find(list_id, email, role = 'member')
      response = get("/lists/#{list_id}/#{role}/#{email}").parsed_response
      new(response)
    end

    def self.create(attributes)
      unless attributes.has_key?(:list_id) && attributes[:list_id] != ''
        raise ArgumentError,
          "You need to provide the 'list_id' to create a new membership."
      end
      unless attributes.has_key?(:subscriber) && attributes[:subscriber] != ''
        raise ArgumentError,
          "You need to provide a 'subscriber' attribute with the email of the new member."
      end
      response = post('/members', body: attributes).parsed_response
      if response.nil?
        true
      else
        response['token']
      end
    end

    def self.destroy(list_id, email, role = 'member')
      member = find(list_id, email, role)
      delete("/members/#{member.member_id}")
      true
    end
  end
end
