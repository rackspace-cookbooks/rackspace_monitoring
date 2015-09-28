shared_examples_for 'agent config' do |agent, filename|
  filename = agent unless filename
  it 'calls rackspace_monitoring_check resource' do
    expect(chef_run).to create_rackspace_monitoring_check(agent)
  end
  it "defines rackspace-monitoring-agent service and creates #{agent} config" do
    expect(chef_run.service('rackspace-monitoring-agent')).to do_nothing
    expect(chef_run).to create_directory('/etc/rackspace-monitoring-agent.conf.d')
    expect(chef_run.template("/etc/rackspace-monitoring-agent.conf.d/#{filename}.yaml")).to notify('service[rackspace-monitoring-agent]').to(:restart).delayed
    expect(chef_run).to render_file("/etc/rackspace-monitoring-agent.conf.d/#{filename}.yaml").with_content(agent)
    params = [
      'disabled: false',
      'period: 90',
      'timeout: 30',
      "Check for #{agent}",
      'notification_plan_id: npTechnicalContactsEmail'
    ]
    params.each do |param|
      expect(chef_run).to render_file("/etc/rackspace-monitoring-agent.conf.d/#{filename}.yaml").with_content(param)
    end
  end
end
