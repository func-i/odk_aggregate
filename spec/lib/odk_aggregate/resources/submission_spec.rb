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
      let(:body_as_hash) do
        {
          "submission"=> {
            "xmlns"=>"http://opendatakit.org/submissions",
            "xmlns:orx"=>"http://openrosa.org/xforms",
            "data"=>{
              "Survey_10_22"=>{
                "id"=>"Survey_10-22",
                "instanceID"=>"uuid:12345abc",
                "Name"=>"Mm",
                "ID"=>"2",
                "Height"=>"9",
                "Photo"=>"1407845936988.jpg",
                "meta"=>{
                  "instanceID"=>"uuid:aa5c7780-b330-4cab-aa56-57c3c273a404"}}},
            "mediaFile" => Helper.mediafile_hash(download_url)}
        }
      end
      let(:body_as_xml) do
        %Q{
            <submission xmlns="http://opendatakit.org/submissions" xmlns:orx="http://openrosa.org/xforms" >
              <data>
                <Survey_10-22 id="Survey_10-22" instanceID="uuid:12345abc">
                  <Name>Mm</Name>
                  <ID>2</ID>
                  <Height>9</Height>
                  <Photo>1407845936988.jpg</Photo>
                  <orx:meta>
                    <orx:instanceID>uuid:aa5c7780-b330-4cab-aa56-57c3c273a404</orx:instanceID>
                  </orx:meta>
                </Survey_10-22>
              </data>
              <mediaFile>
                <filename>1407845936988.jpg</filename>
                <hash>md5:55a54008ad1ba589aa210d2629c1df41</hash>
                <downloadUrl>#{download_url}</downloadUrl>
              </mediaFile>
            </submission>
        }
      end
      let(:body_as_xml_bad_md5) do
        %Q{
            <submission xmlns="http://opendatakit.org/submissions" xmlns:orx="http://openrosa.org/xforms" >
              <data>
                <Survey_10-22 id="Survey_10-22" instanceID="uuid:12345abc">
                  <Name>Mm</Name>
                  <ID>2</ID>
                  <Height>9</Height>
                  <Photo>1407845936988.jpg</Photo>
                  <orx:meta>
                    <orx:instanceID>uuid:aa5c7780-b330-4cab-aa56-57c3c273a404</orx:instanceID>
                  </orx:meta>
                </Survey_10-22>
              </data>
              <mediaFile>
                <filename>1407845936988.jpg</filename>
                <hash>md5:11111111111111111111111111111111</hash>
                <downloadUrl>#{download_url}</downloadUrl>
              </mediaFile>
            </submission>
        }
      end
      let(:body_as_xml_sans_mediafile) do
        %Q{
            <submission xmlns="http://opendatakit.org/submissions" xmlns:orx="http://openrosa.org/xforms" >
              <data>
                <Survey_10-22 id="Survey_10-22" instanceID="uuid:12345abc">
                  <Name>Mm</Name>
                  <ID>2</ID>
                  <Height>9</Height>
                  <Photo>1407845936988.jpg</Photo>
                  <orx:meta>
                    <orx:instanceID>uuid:aa5c7780-b330-4cab-aa56-57c3c273a404</orx:instanceID>
                  </orx:meta>
                </Survey_10-22>
              </data>
            </submission>
        }
      end
      let(:download_url) { "https://not.really.a.url" }
      let(:file_response) { double(Object, body: Helper.attachment_contents) }
      let(:key) { "123" }
      let(:formId) { "456" }
      let(:topElement) { "xyz" }
      let(:response) { double(Object, body: body_as_xml) }
      let(:response_bad_md5) { double(Object, body: body_as_xml_bad_md5) }
      let(:response_sans_mediafile) { double(Object, body: body_as_xml_sans_mediafile) }
      let(:submission_as_hash_with_file_contents) do
        {
          "submission" => body_as_hash["submission"].merge("mediaFile" => Helper.mediafile_with_file_contents_hash(download_url))
        }
      end

      it "downloads the requested submission" do
        submission_hash = {formId: "#{formId}[@version=null and @uiVersion=null]/#{topElement}[@key=#{key}]"}
        expect(connection).to receive(:get).with('view/downloadSubmission', submission_hash).and_return(response)

        subject.submissions_where({formId: formId, topElement: topElement, key: key})
      end

      it "represents the submission as a hash" do
        allow(connection).to receive(:get).with('view/downloadSubmission', anything).and_return(response)

        expect(subject.submissions_where({formId: formId, topElement: topElement, key: key})).to eql(body_as_hash)
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
