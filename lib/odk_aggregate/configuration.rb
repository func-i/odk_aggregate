require 'odk_aggregate/utils'

module OdkAggregate
  module Configuration

    extend OdkAggregate::Utils
    mattr_accessor :version, :language, :base_url, :username, :password

    def version
      @version ||= "1.0"
    end

    def language
      @language ||= "en"
    end

    def base_url
      @base_url ||= "https://opendatakit.appspot.com/"
    end

    def username
      @username
    end

    def password
      @password
    end

    def configure
      yield self if block_given?
    end
  end
end
