# frozen_string_literal: true
# comments!

rackspace_monitoring_check 'agent.filesystem' do
  type 'agent.filesystem'
  target '/var'
  alarm true
  action :create
end
