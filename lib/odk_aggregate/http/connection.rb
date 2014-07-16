require 'base64'
#require 'faraday'
require 'odk_aggregate/http/digestauth'

require 'odk_aggregate/resources/form'
require 'odk_aggregate/resources/submission'


module OdkAggregate
  class Connection

    include OdkAggregate::Configuration
    include OdkAggregate::Form
    include OdkAggregate::Submission

    def initialize(url = nil, username = nil, password = nil)
      url = base_url if url.blank?
      connect(url, username, password)
    end

    private

    def connect(url, username = nil, password = nil)
      @connection ||= Faraday.new(url, connection_options) do |connection|
        connection.response :xml
        connection.use FaradayMiddleware::Rashify
        connection.response :logger
        connection.adapter :net_http
      end

      @connection.digest_auth username, password if username && password
    end


    def connection_options(username = nil, password = nil)
      @connection_options ||= {
        headers: {
          "X-OpenRosa-Version" => version,
          "Accept-Language" => language,
          "user_agent" => "OdkAggregate Gem #{OdkAggregate.version}"
        },
        request: {
          open_timeout: 10,
          timeout: 30
        }
      }

      # if username && password
      #   basicAuthString = Base64.strict_encode64("#{username}:#{password}")
      #   @connection_options[:headers]["Authorization"] = "Basic #{basicAuthString}"
      # end

      @connection_options
    end
  end
end
