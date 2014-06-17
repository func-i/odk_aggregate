module OdkAggregate
  class SubmissionListResponse

    def initialize(response)
      @response = response
    end

    def to_s
      "<OdkAggregate::SubmissionListResponse methods='submissions, opaque_data'>"
    end

    def full_response
      @response
    end

    def submissions
      if @response["idChunk"]
        resp =  @response["idChunk"]["idList"] ? @response["idChunk"]["idList"]["id"] : []
      else
        raise "An error occurred while retreiving submissions"
      end
      resp.is_a?(Array) ? resp : [resp]
    end

    def opaque_data
      @response ? @response["idChunk"]["resumptionCursor"] : nil
    end

  end
end