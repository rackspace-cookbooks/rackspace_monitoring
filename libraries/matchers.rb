if defined?(ChefSpec)
  # service
  def create_rackspace_monitoring_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_service, :create, resource_name)
  end

  def delete_rackspace_monitoring_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_service, :delete, resource_name)
  end

  def start_rackspace_monitoring_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_service, :start, resource_name)
  end

  def stop_rackspace_monitoring_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_service, :stop, resource_name)
  end

  def restart_rackspace_monitoring_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_service, :restart, resource_name)
  end

  def reload_rackspace_monitoring_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_service, :reload, resource_name)
  end

  # check
  def create_rackspace_monitoring_check(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_check, :create, resource_name)
  end

  def delete_rackspace_monitoring_check(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_check, :delete, resource_name)
  end

  def disable_rackspace_monitoring_check(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_check, :disable, resource_name)
  end

  def enable_rackspace_monitoring_check(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_monitoring_check, :enable, resource_name)
  end
end
