module Mailman3
  class List < Base
    attr_accessor :display_name, :fqdn_listname, :list_id, :list_name,
      :mail_host, :member_count, :self_link, :volume

    def self.all(domain = nil)
      path = if domain.nil?
               '/lists'
             else
               "/domains/#{domain}/lists"
             end
      response = get(path).parsed_response
      response['entries'] ||= []
      response['entries'].map do |entry|
        new(entry)
      end
    end

    def self.find(list_id)
      response = get("/lists/#{list_id}").parsed_response
      new(response)
    end

    def self.create(attributes)
      unless attributes.has_key?(:fqdn_listname) && attributes[:fqdn_listname] != ''
        raise ArgumentError,
          "You need to at least provide the 'fqdn_listname' attribute to create a new list."
      end
      response = post('/lists', body: attributes).parsed_response
      new(get(response['location']).parsed_response)
    end

    def self.destroy(list_id)
      delete("/lists/#{list_id}")
      true
    end

    def config
      response = self.class.get("/lists/#{list_id}/config").parsed_response
      result = Hash.new
      response.each do |key, value|
        result[key.to_sym] = value
      end
      result
    end

    def update_config(attributes)
      self.class.patch("/lists/#{list_id}/config", body: attributes)
      true
    end
  end
end
