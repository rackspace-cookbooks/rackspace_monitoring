# comments!

rackspace_monitoring_check 'agent.plugin' do
  type 'agent.plugin'
  plugin_url 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/chef_node_checkin.py'
  # omitted as a regression test.
  # plugin_args nil
  plugin_filename 'awesome_plugin.py'
  alarm true
  action :create
end
