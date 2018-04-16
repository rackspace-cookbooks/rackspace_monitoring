# frozen_string_literal: true

# comments!

rackspace_monitoring_check 'agent.cpu' do
  type 'agent.cpu'
  alarm true
  action :create
end
