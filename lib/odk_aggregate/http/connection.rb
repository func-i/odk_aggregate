require 'faraday_middleware'

require 'odk_aggregate/resources/form'
require 'odk_aggregate/resources/submission'


module OdkAggregate
  class Connection

    include OdkAggregate::Configuration
    include OdkAggregate::Form
    include OdkAggregate::Submission

    def initialize(url = nil)
      url = base_url if url.blank?
      connect(url)
    end

    private

    def connect(url)
      @connection ||= Faraday.new(url, connection_options) do |connection|
        connection.response :xml
        connection.use FaradayMiddleware::Rashify

        connection.adapter :net_http
      end
    end


    def connection_options
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
    end
  end
end
