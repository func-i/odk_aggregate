module OdkAggregate
  class FormResponse

    def initialize(response)
      @response = response
    end

    def full_response
      @response
    end

    def download_url
      @response["downloadUrl"]
    end

    def manifest_url
      @response["manifestUrl"]
    end

    def form_id
      @response["formID"]
    end

    def fields
      response = MultiXml.parse Faraday.new(download_url).get.body.gsub("\n", ""), typecast_xml_value: false
      response["html"]["head"]["model"]["bind"]
    end

    def get_top_element
      response = MultiXml.parse Faraday.new(download_url).get.body.gsub("\n", ""), typecast_xml_value: false
      response["html"]["head"]["model"]["bind"].first["nodeset"].split("/")[1]
    end
  end
end