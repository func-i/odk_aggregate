require 'odk_aggregate/utils'

module OdkAggregate
  module Configuration

    extend OdkAggregate::Utils
    mattr_accessor :version, :language

    def version
      @version ||= "1.0"
    end

    def language
      @language ||= "en"
    end

    def base_url
      "https://opendatakit.appspot.com/"
    end

    def configure
      yield self if block_given?
    end
  end
end