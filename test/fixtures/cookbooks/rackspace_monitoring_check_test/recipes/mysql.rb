# frozen_string_literal: true

# comments!

rackspace_monitoring_check 'agent.mysql' do
  type 'agent.mysql'
  alarm true
  variables 'username' => 'admin',
            'password' => 'hunter2'
  action :create
end
