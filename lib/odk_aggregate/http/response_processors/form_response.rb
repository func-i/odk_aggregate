require 'uri'

module OdkAggregate
  class FormResponse

    def initialize(response, connection, username, password)
      @response = response
      @connection = connection
      @username = username
      @password = password
      @download_url = download_url
    end

    def full_response
      @response
    end

    def download_url
      url = URI(@response["downloadUrl"])
      url.path.to_s + "?" +  url.query.to_s
    end

    def manifest_url
      @response["manifestUrl"]
    end

    def form_id
      @response["formID"]
    end

    def fields
      resp = @connection.send(:get, @download_url).body
      response = MultiXml.parse resp, typecast_xml_value: false
      response["html"]["head"]["model"]["bind"]
      #response = @connection.send(:get, @download_url)
      #response.body["html"]["head"]["model"]["bind"].reject { |f| f.empty? }
    end

    def get_top_element
      resp = @connection.send(:get, @download_url).body
      response = MultiXml.parse resp, typecast_xml_value: false
      response["html"]["head"]["model"]["bind"].first["nodeset"].split("/")[1]
      #response = @connection.send(:get, @download_url)
      #response.body["html"]["head"]["model"]["bind"].reject { |f| f.empty? }.first["nodeset"].split("/")[1]
    end
  end
end
