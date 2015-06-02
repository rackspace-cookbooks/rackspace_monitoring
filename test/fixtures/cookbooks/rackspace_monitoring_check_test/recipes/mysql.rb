# comments!

rackspace_monitoring_check 'agent.mysql' do
  type 'agent.mysql'
  variables 'username' => 'admin',
            'password' => 'hunter2'
  action :create
end
