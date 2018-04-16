# frozen_string_literal: true

# comments!

rackspace_monitoring_check 'agent.load' do
  type 'agent.load'
  alarm true
  action :create
end
