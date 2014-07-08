require "odk_aggregate/version"
require 'odk_aggregate/configuration'
require 'odk_aggregate/http/connection'

require 'odk_aggregate/resources/submission'
require 'odk_aggregate/resources/form'

module OdkAggregate
  extend OdkAggregate::Configuration
#  extend OdkAggregate::Connection
end
