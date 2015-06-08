module RackspaceMonitoringCookbook
  # Helpers for the providers
  module Helpers
    # Get the alarms criteria
    module AlarmCriteria
      require 'erb'
      def template_criteria(type)
        template = File.read("#{File.dirname(__FILE__)}/../templates/default/libraries/#{type}.erb")
        ERB.new(template).result(binding)
      end

      def alarm_criteria_agent_memory
        template_criteria('agent_memory')
      end

      def alarm_criteria_agent_disk
        fail 'There is no relevant default alarm_criteria for agent.disk, please provide :alarm_criteria' if new_resource.alarm && new_resource.target
      end

      def alarm_criteria_agent_cpu
        template_criteria('agent_cpu')
      end

      def alarm_criteria_agent_load
        template_criteria('agent_load')
      end

      def alarm_criteria_agent_filesystem
        template_criteria('agent_filesystem')
      end

      def alarm_criteria_agent_network
        {
          'recv' => template_criteria('agent_network_recv'),
          'send' => template_criteria('agent_network_send')
        }
      end

      def alarm_criteria_remote_http
        template_criteria('remote_http')
      end
    end

    # Get params after they've been processed/filtered
    module ParsedParams
      include RackspaceMonitoringCookbook::Helpers::AlarmCriteria

      def parsed_agent_filename
        return new_resource.agent_filename if new_resource.agent_filename
        # default to type if no filename specified
        new_resource.type
      end

      def parsed_label
        return new_resource.label if new_resource.label
        "Check for #{new_resource.type}"
      end

      def parsed_cloud_credentials_username
        return new_resource.cloud_credentials_username if new_resource.cloud_credentials_username
        fail 'Cloud credential username missing, cannot setup cloud-monitoring (please set :cloud_credentials_username)'
      end

      def parsed_cloud_credentials_api_key
        return new_resource.cloud_credentials_api_key if new_resource.cloud_credentials_api_key
        fail 'Cloud credential api_key missing, cannot setup cloud-monitoring (please set :cloud_credentials_api_key)'
      end

      def parsed_target_hostname
        return new_resource.target_hostname if new_resource.target_hostname
        node['cloud']['public_ipv4']
      end

      def parsed_target
        return new_resource.target.split if new_resource.target
        case new_resource.type
        when 'agent.disk'
          Chef::Log.warn("No target specified for #{new_resource.type}, disabling alarm(as there is not default) and looking for target...")
          target_disk
        when 'agent.filesystem'
          Chef::Log.warn("No target specified for #{new_resource.type}, looking for target...")
          target_filesystem
        when 'agent.network'
          Chef::Log.warn("No target specified for #{new_resource.type}, looking for target...")
          target_network
        end
      end

      def parsed_alarm
        case new_resource.type
        # Disable alarm for agent_disk if not target was specified
        when 'agent.disk'
          return false unless new_resource.alarm_criteria
          return new_resource.alarm
        else
          new_resource.alarm
        end
      end

      def parsed_send_warning
        return new_resource.send_warning if new_resource.send_warning
        fail "You must define :send_warning for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
      end

      def parsed_send_critical
        return new_resource.send_critical if new_resource.send_critical
        fail "You must define :send_critical for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
      end

      def parsed_recv_warning
        return new_resource.recv_warning if new_resource.recv_warning
        fail "You must define :recv_warning for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
      end

      def parsed_recv_critical
        return new_resource.recv_critical if new_resource.recv_critical
        fail "You must define :recv_critical for #{new_resource.type} if you enabled alarm" if new_resource.type == 'agent.network' && new_resource.alarm
      end

      # Get filename from URI if not defined
      def parsed_plugin_filename
        return new_resource.plugin_filename if new_resource.plugin_filename
        if new_resource.plugin_url
          File.basename(URI(new_resource.plugin_url).request_uri)
        elsif new_resource.type == 'agent.plugin'
          fail "You must specify at least a :plugin_filename for #{new_resource.name}"
        end
      end

      def parsed_alarm_criteria
        return new_resource.alarm_criteria if new_resource.alarm_criteria
        supported_alarm_criteria = %w( agent.memory agent.cpu agent.load agent.filesystem agent.disk agent.network remote.http)
        send('alarm_criteria_' + new_resource.type.gsub('.', '_')) if supported_alarm_criteria.include?(new_resource.type)
      end

      def parsed_template_from_type
        return new_resource.template if new_resource.template
        if %w( agent.memory agent.cpu agent.load agent.filesystem agent.disk agent.network remote.http agent.plugin).include?(new_resource.type)
          "#{new_resource.type}.conf.erb"
        else
          Chef::Log.info("Using custom monitor for #{new_resource.type}")
          'agent.custom.conf.erb'
        end
      end

      def parsed_template_variables(disabled)
        {
          cookbook: new_resource.cookbook,
          label: parsed_label,
          disabled: disabled,
          type: new_resource.type,
          alarm: parsed_alarm,
          alarm_criteria: parsed_alarm_criteria,
          period: new_resource.period,
          timeout: new_resource.timeout,
          critical: new_resource.critical,
          warning: new_resource.warning,
          notification_plan_id: new_resource.notification_plan_id,
          target: parsed_target,
          target_hostname: parsed_target_hostname,
          send_warning: parsed_send_warning,
          send_critical: parsed_send_critical,
          recv_warning: parsed_recv_warning,
          recv_critical: parsed_recv_critical,
          plugin_filename: parsed_plugin_filename,
          # Using inspect so it dumps a string representing an array
          plugin_args: new_resource.plugin_args.inspect,
          plugin_timeout: new_resource.plugin_timeout,
          variables: new_resource.variables
        }
      end
    end

    # Static path
    module StaticParams
      def agent_conf_d
        '/etc/rackspace-monitoring-agent.conf.d'
      end

      def plugin_path
        '/usr/lib/rackspace-monitoring-agent/plugins'
      end
    end

    # Any other helpers (mainly Chef resources)
    module Other
      include Chef::DSL::IncludeRecipe
      include RackspaceMonitoringCookbook::Helpers::ParsedParams
      include RackspaceMonitoringCookbook::Helpers::StaticParams

      def create_agent_conf_d
        directory agent_conf_d do
          owner 'root'
          group 'root'
          mode 00755
        end
      end

      def configure_package_repositories
        if %w(rhel fedora).include? node['platform_family']
          yum_repository 'monitoring' do
            description 'Rackspace Cloud Monitoring agent repo'
            baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['platform_version'][0]}-x86_64"
            gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
            enabled true
            gpgcheck true
            action :add
          end
        else
          apt_repository 'monitoring' do
            uri "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
            distribution 'cloudmonitoring'
            components ['main']
            key 'https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc'
            action :add
          end
        end
      end

      def target_filesystem
        target = []
        excluded_fs = %(tmpfs devtmpfs devpts proc mqueue cgroup efivars sysfs sys securityfs configfs fusectl pstore)
        unless node['filesystem'].nil?
          node['filesystem'].each do |key, data|
            next if data['percent_used'].nil? || data['fs_type'].nil?
            next if excluded_fs.include?(data['fs_type'])
            Chef::Log.warn("Found filesystem : #{data['mount']}")
            target << data['mount']
          end
        end
        target
      end

      def target_disk
        target = []
        node['filesystem'].each do |key, data|
          if key =~ %r{^/dev/(sd|vd|xvd|hd)[a-z]}
            Chef::Log.warn("Found disk : #{key}")
            target << key
          end
        end
        target
      end

      def target_network
        Chef::Log.warn("Found default interface : #{node['network']['default_interface']}")
        node['network']['default_interface'].split
      end

      def sanitize_target(target, type)
        case type
        when 'agent.disk'
          ::File.basename(target)
        when 'agent.filesystem'
          ::File.basename(target).gsub('/', 'slash')
        when 'agent.network'
          target
        end
      end
    end
  end
end
