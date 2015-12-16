require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'rackspace_monitoring_service_shared'
require_relative 'rackspace_monitoring_check_shared'
require_relative '../../../libraries/helpers'

::LOG_LEVEL = ENV['CHEFSPEC_LOG_LEVEL'] ? ENV['CHEFSPEC_LOG_LEVEL'].to_sym : :fatal

CONSTS = Class.new.extend(RackspaceMonitoringCookbook::Helpers::StaticParams)

def stub_resources
  allow(File).to receive(:size?).with('/etc/rackspace-monitoring-agent.cfg').and_return(nil)
end

def node_resources(node)
  node.set['rackspace_monitoring']['cloud_credentials_username'] = 'dummyusername'
  node.set['rackspace_monitoring']['cloud_credentials_api_key'] = 'dummyapikey'
  node.set['cloud']['local_ipv4'] = '10.0.0.1'
end

def find_disks(node)
  node['filesystem'].keys.select { |k| k =~ CONSTS.disks_pattern }
end

def find_filesystems(node)
  mounts = []
  node['filesystem'].each do |k, v|
    next if CONSTS.excluded_fs.include?(v['fs_type'])
    mounts << v['mount']
  end

  mounts
end

at_exit { ChefSpec::Coverage.report! }
