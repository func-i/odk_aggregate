require 'spec_helper'

describe OdkAggregate::Submission do
  class Container
    def initialize(connection)
      @connection = connection
    end
  end
  let(:connection) { double }
  subject do
    c = Container.new connection
    c.extend described_class
    c
  end

  describe "#submissions_where" do
    it "raises an exception if not provided with a formId" do
      expect { subject.submissions_where({}) }.to raise_error "formId required"
    end

    context "key provided" do
      let(:submission_as_hash) { Helper.submission_hash }
      let(:submission_as_xml) { Helper.submission_as_xml }
      let(:submission_as_xml_bad_md5) { Helper.submission_as_xml_bad_md5 }
      let(:submission_as_xml_sans_mediafile) { Helper.submission_as_xml_sans_mediafile }
      let(:download_url) { Helper.download_url }
      let(:file_response) { double(Object, body: Helper.attachment_contents) }
      let(:key) { "123" }
      let(:formId) { "456" }
      let(:topElement) { "xyz" }
      let(:response) { double(Object, body: submission_as_xml) }
      let(:response_bad_md5) { double(Object, body: submission_as_xml_bad_md5) }
      let(:response_sans_mediafile) { double(Object, body: submission_as_xml_sans_mediafile) }
      let(:submission_as_hash_with_file_contents) do
        Helper.submission_as_hash_with_file_contents
      end

      it "downloads the requested submission" do
        submission_hash = {formId: "#{formId}[@version=null and @uiVersion=null]/#{topElement}[@key=#{key}]"}
        expect(connection).to receive(:get).with('view/downloadSubmission', submission_hash).and_return(response)

        subject.submissions_where({formId: formId, topElement: topElement, key: key})
      end

      it "represents the submission as a hash" do
        allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response)

        expect(subject.submissions_where({formId: formId, topElement: topElement, key: key})).to eql(submission_as_hash)
      end

      context "requesting the mediafile" do
        let(:params) do
          { formId: formId, topElement: topElement, key: key, fetch_mediafile: true }
        end
        it "downloads the mediafile if requested" do
          expect(connection).to receive(:get).with(download_url).and_return(file_response)
          allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response)

          subject.submissions_where(params)
        end

        it "does not fetch the mediafile if not requested" do
          expect(connection).to_not receive(:get).with(download_url)
          allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response)

          subject.submissions_where(formId: formId, topElement: topElement, key: key)
        end

        it "does not attempt fetching the media file if no data is provided wit the submission" do
          allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response_sans_mediafile)

          expect { subject.submissions_where(params) }.to_not raise_error
        end

        it "returns the file contents as part of the response" do
          allow(connection).to receive(:get).with(download_url).and_return(file_response)
          allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response)

          expect(subject.submissions_where(params)).to eql submission_as_hash_with_file_contents
        end

        it "raises an error if the MD5 of the contents does not match the MD5 supplied with the submission" do
          allow(connection).to receive(:get).with(download_url).and_return(file_response)
          allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response_bad_md5)

          expect { subject.submissions_where(params) }.to raise_error "MD5 signature mismatch for submission mediaFile"
        end
      end
    end
  end
end
