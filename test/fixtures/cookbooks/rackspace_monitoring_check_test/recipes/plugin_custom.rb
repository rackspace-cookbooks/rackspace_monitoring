# comments!

rackspace_monitoring_check 'agent.plugin' do
  type 'agent.plugin'
  plugin_cookbook 'rackspace_monitoring_check_test'
  plugin_filename 'dummy.sh'
  alarm true
  action :create
end
