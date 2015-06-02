# comments!

rackspace_monitoring_check 'agent.apache' do
  type 'agent.apache'
  variables 'url' => 'http://example.com/server-status'
  action :create
end
