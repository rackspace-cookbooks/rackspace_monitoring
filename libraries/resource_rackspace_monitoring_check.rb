require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # Resource definition for rackspace_monitoring_check
    class RackspaceMonitoringCheck < Chef::Resource::LWRPBase
      self.resource_name = :rackspace_monitoring_check
      actions :create, :delete, :enable, :disable
      default_action :create

      # Common to all checks
      attribute :label, kind_of: String, default: nil
      attribute :agent_filename, kind_of: String, default: nil
      attribute :alarm, kind_of: [TrueClass, FalseClass], default: false
      attribute :alarm_criteria, kind_of: [String, Hash], default: nil
      attribute :period, kind_of: Fixnum, default: 90
      attribute :timeout, kind_of: Fixnum, default: 30
      attribute :critical, kind_of: Fixnum, default: 95
      attribute :warning, kind_of: Fixnum, default: 90
      attribute :variables, kind_of: Hash, default: {}
      attribute :notification_plan_id, kind_of: String, default: 'npTechnicalContactsEmail'
      # Required on some checks (filesystem/disk/network)
      attribute :target, kind_of: String, default: nil
      attribute :target_hostname, kind_of: String, default: nil
      attribute :send_warning, kind_of: Fixnum, default: 18_350_080
      attribute :send_critical, kind_of: Fixnum, default: 24_903_680
      attribute :recv_warning, kind_of: Fixnum, default: 18_350_080
      attribute :recv_critical, kind_of: Fixnum, default: 24_903_680
      # Plugins attributes
      attribute :plugin_url, kind_of: String, default: nil
      attribute :plugin_args, kind_of: Array, default: nil
      attribute :plugin_filename, kind_of: String, default: nil
      attribute :plugin_timeout, kind_of: Fixnum, default: 30
      # Template config
      attribute :cookbook, kind_of: String, default: 'rackspace_monitoring'
      attribute :template, kind_of: String, default: nil
      attribute :type, kind_of: String, default: nil
    end
  end
end
