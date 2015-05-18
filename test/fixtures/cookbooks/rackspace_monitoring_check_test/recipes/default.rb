# Used by chefspec to create different context (attributes)

rackspace_monitoring_check node['rackspace_monitoring_check_test']['type'] do
  type node['rackspace_monitoring_check_test']['type']
  label node['rackspace_monitoring_check_test']['label']
  alarm node['rackspace_monitoring_check_test']['alarm']
  alarm_criteria node['rackspace_monitoring_check_test']['alarm_criteria']
  period node['rackspace_monitoring_check_test']['period']
  timeout node['rackspace_monitoring_check_test']['timeout']
  critical node['rackspace_monitoring_check_test']['critical']
  warning node['rackspace_monitoring_check_test']['warning']
  variables node['rackspace_monitoring_check_test']['variables']
  target node['rackspace_monitoring_check_test']['target']
  target_hostname node['rackspace_monitoring_check_test']['target_hostname']
  send_warning node['rackspace_monitoring_check_test']['send_warning']
  send_critical node['rackspace_monitoring_check_test']['send_critical']
  recv_warning node['rackspace_monitoring_check_test']['recv_warning']
  recv_critical node['rackspace_monitoring_check_test']['recv_critical']
  plugin_url node['rackspace_monitoring_check_test']['plugin_url']
  plugin_filename node['rackspace_monitoring_check_test']['plugin_filename']
  plugin_args node['rackspace_monitoring_check_test']['plugin_args']
  cookbook node['rackspace_monitoring_check_test']['cookbook']
  template node['rackspace_monitoring_check_test']['template']
  action :create
end
