module OdkAggregate
  class FormResponse

    def initialize(response)
      @response = response
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

    def get_top_element
      response = MultiXml.parse Faraday.new(download_url).get.body.gsub("\n", "")
      response["html"]["head"]["model"]["bind"].reject{|a| a.blank?}.first["nodeset"].split("/")[1]
    end
  end
end