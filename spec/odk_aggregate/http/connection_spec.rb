require 'spec_helper'

describe OdkAggregate::Connection do
  describe "on initialisation" do
    let(:connection) { double.as_null_object }
    let(:connection_options) do
      {
        headers: {
          "X-OpenRosa-Version" => "1.0",
          "Accept-Language" => "en",
          "user_agent" => "OdkAggregate Gem #{OdkAggregate.version}"
        },
        request: {
          open_timeout: 10,
          timeout: 30
        },
        ssl: {
          verify: false
        }
      }
    end
    let(:password) { "SecretPass2014" }
    let(:url) { "https://my.awesome.uri" }
    let(:username) { "Bob The Builder" }

    it "establishes a faraday connection" do
      expect(Faraday).to receive(:new).with(url, connection_options).and_return(connection)

      described_class.new url
    end

    it "sets sets the necessary connection properties" do
      allow(Faraday).to receive(:new).and_return(connection).and_yield(connection)
      expect(connection).to receive(:use).with(FaradayMiddleware::Rashify)
      expect(connection).to receive(:response).with(:logger)
      expect(connection).to receive(:adapter).with(:net_http)

      described_class.new url
    end

    it "sets the credentials for digest auth" do
      allow(Faraday).to receive(:new).and_return(connection)
      expect(connection).to receive(:digest_auth).with(username, password)

      described_class.new url, username, password
    end

    it "does not attempt to set up digest auth if the credentials are incomplete" do
      allow(Faraday).to receive(:new).and_return(connection)
      expect(connection).to_not receive(:digest_auth)

      described_class.new url
      described_class.new url, username
      described_class.new url, nil, password
    end

    it "defaults the url if none is provided" do
      expect(Faraday).to receive(:new).with("https://opendatakit.appspot.com/", connection_options).and_return(connection)
      described_class.new

      expect(Faraday).to receive(:new).with("https://opendatakit.appspot.com/", connection_options).and_return(connection)
      described_class.new ""
    end
  end
end
