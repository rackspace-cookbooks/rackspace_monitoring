shared_examples_for 'rackspace monitoring agent set up' do |platform|
  it 'calls rackspace_monitoring_service resource' do
    expect(chef_run).to create_rackspace_monitoring_service('default')
    expect(chef_run).to start_rackspace_monitoring_service('default')
  end
  it 'adds appropriate repository and installs rackspace-monitor-agent' do
    if %w(rhel fedora).include? platform
      expect(chef_run).to add_yum_repository('monitoring')
    else
      expect(chef_run).to add_apt_repository('monitoring')
    end

    expect(chef_run).to install_package('rackspace-monitoring-agent')
  end
  it 'enables and starts rackspace-monitoring-agent service' do
    expect(chef_run).to enable_service('rackspace-monitoring-agent')
    expect(chef_run).to start_service('rackspace-monitoring-agent')
  end
  it 'creates required rackspace-monitoring-agent config directory and runs configuration' do
    expect(chef_run).to create_directory('/etc/rackspace-monitoring-agent.conf.d')
    expect(chef_run).to run_execute('agent-setup-cloud').with(command: 'rackspace-monitoring-agent --setup --username dummyusername --apikey dummyapikey --auto-create-entity')
  end
end

shared_examples_for 'raise error about missing parameters' do
  it 'Runtime error' do
    expect { chef_run }.to raise_error(RuntimeError)
  end
end

shared_examples_for 'agent set up without entity' do
  it 'runs agent setup with no-entity flag' do
    agent_command = 'rackspace-monitoring-agent --setup --username dummyusername --apikey dummyapikey --no-entity'
    expect(chef_run).to run_execute('agent-setup-cloud').with(command: agent_command)
  end
end
