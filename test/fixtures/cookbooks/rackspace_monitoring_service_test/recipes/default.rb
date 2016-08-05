# frozen_string_literal: true
# comments!

rackspace_monitoring_service 'default' do
  cloud_credentials_username node['rackspace_monitoring']['cloud_credentials_username']
  cloud_credentials_api_key node['rackspace_monitoring']['cloud_credentials_api_key']
  package_channel node['rackspace_monitoring']['package_channel']
  create_entity node['rackspace_monitoring']['create_entity']
  action [:create, :start]
end
