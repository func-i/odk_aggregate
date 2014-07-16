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
      #response = MultiXml.parse Faraday.new(download_url).get.body.gsub("\n", ""), typecast_xml_value: false
      #response = MultiXml.parse @connection.send(:get, @download_url).body.gsub("\n", ""), typecast_xml_value: false
      response = @connection.send(:get, @download_url)
      response.body["html"]["head"]["model"]["bind"]
    end

    def get_top_element
      response = MultiXml.parse Faraday.new(@download_url).get.body.gsub("\n", ""), typecast_xml_value: false
      response["html"]["head"]["model"]["bind"].first["nodeset"].split("/")[1]
    end
  end
end
