require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'rackspace_monitoring_service_shared'
require_relative 'rackspace_monitoring_check_shared'

::LOG_LEVEL = ENV['CHEFSPEC_LOG_LEVEL'] ? ENV['CHEFSPEC_LOG_LEVEL'].to_sym : :fatal

def stub_resources
  allow(File).to receive(:size?).with('/etc/rackspace-monitoring-agent.cfg').and_return(nil)
end

def node_resources(node)
  node.set['rackspace_monitoring']['cloud_credentials_username'] = 'dummyusername'
  node.set['rackspace_monitoring']['cloud_credentials_api_key'] = 'dummyapikey'
  node.set['cloud']['local_ipv4'] = '10.0.0.1'
end

at_exit { ChefSpec::Coverage.report! }
