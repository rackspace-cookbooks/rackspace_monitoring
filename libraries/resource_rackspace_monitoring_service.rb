require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # Resource definition for rackspace_monitoring_service
    class RackspaceMonitoringService < Chef::Resource::LWRPBase
      self.resource_name = :rackspace_monitoring_service
      actions :create, :delete, :start, :stop, :restart, :reload
      default_action :create

      attribute :cloud_credentials_username, kind_of: String, default: nil
      attribute :cloud_credentials_api_key, kind_of: String, default: nil
      attribute :package_action, kind_of: Symbol, default: :install
      attribute :package_name, kind_of: String, default: 'rackspace-monitoring-agent'
    end
  end
end
