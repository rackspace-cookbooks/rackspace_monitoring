# frozen_string_literal: true

# comments!

rackspace_monitoring_check 'agent.redis' do
  type 'agent.redis'
  alarm true
  variables 'url' => 'example.com'
  action :create
end
