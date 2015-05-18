# comments!

rackspace_monitoring_check 'agent.memory' do
  type 'agent.memory'
  alarm true
  action :create
end
