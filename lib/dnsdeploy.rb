require 'json'
require 'dnsimple'
require 'pry'

require_relative 'dnsdeploy/version'
require_relative 'dnsdeploy/local'
require_relative 'dnsdeploy/record'
require_relative 'dnsdeploy/base'
require_relative 'core_ext/string'

DNSimple::Client.username = ENV['DNSIMPLE_USERNAME']
DNSimple::Client.api_token = ENV['DNSIMPLE_API_TOKEN']

module Dnsdeploy
end
