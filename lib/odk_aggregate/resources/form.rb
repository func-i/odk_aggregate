require 'odk_aggregate/http/response_processors/form_response'

module OdkAggregate
  class Form

    def self.all
      result = []
      OdkAggregate.connection.send(:get, 'xformsList').body["xforms"]["xform"].each do |f|
        result << OdkAggregate::FormResponse.new(f)
      end
      result
    end

    def self.first
      OdkAggregate::FormResponse.new OdkAggregate.connection.send(:get, 'xformsList').body["xforms"]["xform"].first
    end

    def self.last
      OdkAggregate::FormResponse.new OdkAggregate.connection.send(:get, 'xformsList').body["xforms"]["xform"].last
    end

    def self.find(id)
      OdkAggregate::FormResponse.new OdkAggregate.connection.send(:get, 'xformsList', formID: id, verbose: true).body["xforms"]["xform"]
    end

  end
end