require 'json'
require 'dnsimple'
require 'lazy_loader'

require_relative 'dnsdeploy/version'
require_relative 'dnsdeploy/local'
require_relative 'dnsdeploy/record'
require_relative 'dnsdeploy/base'
require_relative 'core_ext/string'

module Dnsdeploy

  DNSimple::Client.username = _get_env('DNSIMPLE_USERNAME')
  DNSimple::Client.api_token = _get_env('DNSIMPLE_API_TOKEN')

  def self._get_env(env_key)
    raise ArgumentError.new("ENV key #{env_key} not set") unless ENV[env_key] != nil
    ENV[env_key]
  end
end
