require 'odk_aggregate/http/response_processors/submission_list_response'
require 'digest/md5'

module OdkAggregate
  module Submission
    def submissions_where(conditions = {})
      raise "formId required" unless conditions[:formId]
      if conditions[:key]
        get_submission(conditions)
      else
        get_list(conditions)
      end
    end

    protected

    def get_list(conditions)
      resp = @connection.send(:get, 'view/submissionList', conditions).body
      response = MultiXml.parse(resp)
      OdkAggregate::SubmissionListResponse.new(response)
    end

    def get_submission(conditions)
      hash = {
        formId: "#{conditions[:formId]}[@version=null and @uiVersion=null]/#{conditions[:topElement]}[@key=#{conditions[:key]}]"
      }
      resp = @connection.send(:get, 'view/downloadSubmission', hash).body
      response = MultiXml.parse resp

      if response["submission"]["mediaFile"] and conditions[:fetch_mediafile]
        response["submission"]["mediaFile"]["contents"] = get_mediafile_contents(response)
      end

      response
    end

    def get_mediafile_contents(response)
      file_contents = @connection.send(:get, response["submission"]["mediaFile"]["downloadUrl"]).body
      raise  "MD5 signature mismatch for submission mediaFile" unless contents_signature_matches?(response, file_contents)
      file_contents
    end

    def contents_signature_matches?(submission, contents)
      Digest::MD5.hexdigest(contents) == mediaFile_signature(submission)
    end

    def mediaFile_signature(submission_hash)
      submission_hash["submission"]["mediaFile"]["hash"].split(":").last
    end
  end
end
