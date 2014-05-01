require 'faraday_middleware'

module OdkAggregate
  module Connection

    def connection
      @connection ||= Faraday.new(base_url, connection_options) do |connection|
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