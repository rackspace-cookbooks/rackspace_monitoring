require 'chef/resource/lwrp_base'

class Chef
  class Provider
    # Provider definition for rackspace_monitoring_service
    class RackspaceMonitoringService < Chef::Provider::LWRPBase
      include RackspaceMonitoringCookbook::Helpers::Other

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        # Yum, Apt, etc. From helpers.rb
        configure_package_repositories

        # Software installation
        package new_resource.package_name do
          action new_resource.package_action
        end

        # Set up rackspace-monitoring-agent
        execute 'agent-setup-cloud' do
          command "rackspace-monitoring-agent --setup --username #{parsed_cloud_credentials_username} --apikey #{parsed_cloud_credentials_api_key}"
          action 'run'
          # the filesize is zero if the agent has not been configured
          only_if { ::File.size?('/etc/rackspace-monitoring-agent.cfg').nil? }
        end

        # Set directory to put agent configuration
        create_agent_conf_d
        service_enable
      end

      action :delete do
        service_disable
        # Software uninstallation
        package "#{new_resource.name} :delete #{new_resource.package_name}" do
          package_name new_resource.package_name
          action :remove
        end
        directory 'rackspace-monitoring-agent-confd' do
          path agent_conf_d
          owner 'root'
          group 'root'
          mode 00755
          recursive true
          action :delete
        end
      end

      action :enable do
        service_enable
      end

      action :disable do
        service_disable
      end

      action :stop do
        service_stop
      end

      action :start do
        service_start
      end

      action :restart do
        service_restart
      end

      action :reload do
        service_reload
      end

      def service_enable
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action %w(enable)
        end
      end

      def service_disable
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action %w(disable)
        end
      end

      def service_start
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action %w(start)
        end
      end

      def service_stop
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action %w(stop)
        end
      end

      def service_restart
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action %w(restart)
        end
      end

      def service_reload
        service 'rackspace-monitoring-agent' do
          supports start: true, status: true, stop: true, restart: true
          action %w(reload)
        end
      end
    end
  end
end
