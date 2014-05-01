require 'odk_aggregate/http/response_processors/submission_list_response'

module OdkAggregate
  class Submission
    def self.where(conditions = {})
      raise "formId required" unless conditions[:formId]
      if conditions[:key]
        get_submission(conditions)
      else
        get_list(conditions)
      end
    end

    protected

    def self.get_list(conditions)
      response = OdkAggregate.connection.send(:get, 'view/submissionList', conditions).body
      OdkAggregate::SubmissionListResponse.new(response)
    end

    def self.get_submission(conditions)
      hash = {
        formId: "#{conditions[:formId]}[@version=null and @uiVersion=null]/#{conditions[:topElement]}[@key=#{conditions[:key]}]"
      }
      response = OdkAggregate.connection.send(:get, 'view/downloadSubmission', hash).body
    end
  end
end