# frozen_string_literal: true
# comments!

rackspace_monitoring_check 'agent.custom' do
  type 'remote.ping'
  cookbook 'rackspace_monitoring_check_test'
  template 'user_defined.conf.erb'
  alarm true
  variables 'count' => '10'
  action :create
end
