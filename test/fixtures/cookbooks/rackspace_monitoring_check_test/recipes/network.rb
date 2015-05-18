# comments!

rackspace_monitoring_check 'agent.network' do
  type 'agent.network'
  target 'eth0'
  alarm true
  action :create
end
