module Mailman3
  # Class representing a domain. Mailman can handle multiple domains so
  # you can have both list@example.com and list@test.org as completely
  # seperate mailing lists.
  class Domain < Base

    attr_accessor :base_url, :description, :mail_host, :self_link, :url_host

    # Load all domain objects
    def self.all
      response = get('/domains').parsed_response
      response['entries'] ||= []
      response['entries'].map do |entry|
        new(entry)
      end
    end

    def self.find(name)
      response = get("/domains/#{name}").parsed_response
      new(response)
    end

    def self.create(attributes)
      unless attributes.has_key?(:mail_host) && attributes[:mail_host] != ''
        raise ArgumentError,
          "You need to at least provide the 'mail_host' attribute to create a new domain."
      end

      post('/domains', body: attributes)
      find(attributes[:mail_host])
    end

    def self.destroy(name)
      delete("/domains/#{name}")
      true
    end

    def lists
      List.all(mail_host)
    end

    def create_list(name, attributes = {})
      attributes.merge! fqdn_listame: "#{name}@#{mail_host}"
      List.create(attributes)
    end
  end
end
