class Helper
  def self.attachment_contents
    IO.binread(File.join(File.dirname(__FILE__), '..', 'fixtures', 'tiny_binary_file'))
  end

  def self.mediafile_hash(download_url)
    {
      "filename"=>"1407845936988.jpg",
      "hash"=>"md5:55a54008ad1ba589aa210d2629c1df41",
      "downloadUrl"=>download_url
    }
  end

  def self.mediafile_bad_md5_hash(download_url)
    {
      "filename"=>"1407845936988.jpg",
      "hash"=>"md5:12345678123456781234567812345678",
      "downloadUrl"=>download_url
    }
  end

  def self.mediafile_with_file_contents_hash(download_url)
    mediafile_hash(download_url).merge "contents" => attachment_contents
  end
end
