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
      @response["idChunk"]["idList"]["id"]
    end

    def opaque_data
      @response["idChunk"]["resumptionCursor"]
    end

  end
end