# frozen_string_literal: true
# comments!

rackspace_monitoring_check 'agent.apache' do
  type 'agent.apache'
  alarm true
  action :create
end
