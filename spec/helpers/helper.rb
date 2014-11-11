class Helper
  def self.attachment_contents
    IO.binread(File.join(File.dirname(__FILE__), '..', 'fixtures', 'tiny_binary_file'))
  end

  def self.mediafile_hash
    {
      "filename"=>"1407845936988.jpg",
      "hash"=>"md5:55a54008ad1ba589aa210d2629c1df41",
      "downloadUrl"=>download_url
    }
  end

  def self.mediafile_bad_md5_hash
    {
      "filename"=>"1407845936988.jpg",
      "hash"=>"md5:12345678123456781234567812345678",
      "downloadUrl"=>download_url
    }
  end

  def self.mediafile_with_file_contents_hash
    mediafile_hash.merge "contents" => attachment_contents
  end

  def self.submission_hash
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
              "mediaFile" => Helper.mediafile_hash}
    }
  end

  def self.submission_as_xml
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

  def self.submission_as_xml_bad_md5
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

  def self.submission_as_xml_sans_mediafile
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

  def self.submission_as_hash_with_file_contents
    {
      "submission" => submission_hash["submission"].merge("mediaFile" => mediafile_with_file_contents_hash)
    }
  end

  def self.download_url
    "https://not.really.a.url"
  end
end
