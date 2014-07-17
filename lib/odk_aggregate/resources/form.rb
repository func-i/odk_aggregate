require 'odk_aggregate/http/response_processors/form_response'

module OdkAggregate
  module Form

    def all_forms
      result = []
      @connection.send(:get, 'xformsList').body["xforms"]["xform"].each do |f|
        result << OdkAggregate::FormResponse.new(f, @connection, @username, @password)
      end
      result
    end

    def first_form
      OdkAggregate::FormResponse.new @connection.send(:get, 'xformsList').body["xforms"]["xform"].first,
                                     @connection, @username, @password
    end

    def last_form
      OdkAggregate::FormResponse.new @connection.send(:get, 'xformsList').body["xforms"]["xform"].last,
                                     @connection, @username, @password
    end

    def find_form(id)
      OdkAggregate::FormResponse.new @connection.send(:get, 'xformsList', formID: id, verbose: true).body["xforms"]["xform"],
                                     @connection, @username, @password
    end

  end
end
