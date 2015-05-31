require_relative 'spec_helper'

describe 'rackspace_monitoring_check_test::* on Ubuntu 12.04' do
  before do
    stub_resources
  end

  UBUNTU1204_CHECK_OPTS = {
    log_level: LOG_LEVEL,
    platform: 'ubuntu',
    version: '12.04',
    step_into: ['rackspace_monitoring_check']
  }

  context 'Any check' do
    context 'rackspace_monitoring_check built from parameters' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.network'
          node.set['rackspace_monitoring_check_test']['label'] = 'Awesome label, for an awesome check'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
          node.set['rackspace_monitoring_check_test']['alarm_criteria']['recv'] = 'custom_recv_criteria'
          node.set['rackspace_monitoring_check_test']['alarm_criteria']['send'] = 'custom_send_criteria'
          node.set['rackspace_monitoring_check_test']['period'] = 666
          node.set['rackspace_monitoring_check_test']['timeout'] = 555
          node.set['rackspace_monitoring_check_test']['critical'] = 444
          node.set['rackspace_monitoring_check_test']['warning'] = 333
          node.set['rackspace_monitoring_check_test']['target'] = 'dummy_eth'
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'configure my agent with all me resources parameters' do
        params = [
          'type: agent.network',
          'disabled: false',
          'period: 666',
          'label: Awesome label, for an awesome check',
          'timeout: 555',
          'target: dummy_eth',
          'alarm-network-receive',
          'custom_recv_criteria',
          'custom_send_criteria'
        ]
        params.each do |param|
          expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.network.dummy_eth.yaml').with_content(param)
        end
      end
    end
  end

  context 'CPU check' do
    context 'rackspace_monitoring_check for cpu' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::cpu')
      end
      it_behaves_like 'agent config', 'agent.cpu'
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.cpu.yaml'
        expect(chef_run).to render_file(agent_config).with_content('metric[\'usage_average\'] > 95')
        expect(chef_run).to render_file(agent_config).with_content('metric[\'usage_average\'] > 90')
        expect(chef_run).to render_file(agent_config).with_content('CPU usage is #{usage_average}%, above your critical threshold of 95%')
        expect(chef_run).to render_file(agent_config).with_content('CPU usage is #{usage_average}%, above your warning threshold of 90%')
        expect(chef_run).to render_file(agent_config).with_content('CPU usage is #{usage_average}%, below your warning threshold of 90%')
      end
    end
  end
  context 'HTTP check' do
    context 'rackspace_monitoring_check for http' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::http')
      end
      it_behaves_like 'agent config', 'remote.http'
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/remote.http.yaml'
        expect(chef_run).to render_file(agent_config).with_content("metric['code'] regex '4[0-9][0-9]'")
        expect(chef_run).to render_file(agent_config).with_content("metric['code'] regex '5[0-9][0-9]")
        expect(chef_run).to render_file(agent_config).with_content('HTTP server responding with 4xx status')
        expect(chef_run).to render_file(agent_config).with_content('HTTP server responding with 5xx status')
        expect(chef_run).to render_file(agent_config).with_content('HTTP server is functioning normally')
      end
    end
  end

  context 'Load check' do
    context 'rackspace_monitoring_check for load' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::load')
      end
      it_behaves_like 'agent config', 'agent.load'
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.load.yaml'
        expect(chef_run).to render_file(agent_config).with_content("metric['5m'] > 95")
        expect(chef_run).to render_file(agent_config).with_content("metric['5m'] > 90")
        expect(chef_run).to render_file(agent_config).with_content('5 minute load average is #{5m}, above your critical threshold of 95')
        expect(chef_run).to render_file(agent_config).with_content('5 minute load average is #{5m}, above your warning threshold of 90')
        expect(chef_run).to render_file(agent_config).with_content('5 minute load average is #{5m}, below your warning threshold of 90')
      end
    end
  end

  context 'Memory check' do
    context 'rackspace_monitoring_check for memory' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::memory')
      end
      it_behaves_like 'agent config', 'agent.memory'
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.memory.yaml'
        expect(chef_run).to render_file(agent_config).with_content("percentage(metric['actual_used'], metric['total']) > 95")
        expect(chef_run).to render_file(agent_config).with_content("percentage(metric['actual_used'], metric['total']) > 90")
        expect(chef_run).to render_file(agent_config).with_content('Memory usage is above your critical threshold of 95%')
        expect(chef_run).to render_file(agent_config).with_content('Memory usage is above your warning threshold of 90%')
        expect(chef_run).to render_file(agent_config).with_content('Memory usage is below your warning threshold of 90%')
      end
    end
  end

  context 'Network check' do
    context 'rackspace_monitoring_check' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::network')
      end
      it_behaves_like 'agent config', 'agent.network', 'agent.network.eth0'
    end
    context 'rackspace_monitoring_check with missing target attribute' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.network'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'creates a config for each detected target' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.network.eth0.yaml')
      end
    end
    context 'rackspace_monitoring_check with custom alarm thresholds' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.network'
          node.set['rackspace_monitoring_check_test']['target'] = 'dummy_target'
          node.set['rackspace_monitoring_check_test']['send_warning'] = 9999
          node.set['rackspace_monitoring_check_test']['send_critical'] = 8888
          node.set['rackspace_monitoring_check_test']['recv_warning'] = 7777
          node.set['rackspace_monitoring_check_test']['recv_critical'] = 6666
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'configures the agent.yaml with the corrects alarm thresholds' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.network.dummy_target.yaml'
        expect(chef_run).to render_file(agent_config).with_content('transmit rate is above your warning threshold of 9999')
        expect(chef_run).to render_file(agent_config).with_content('transmit rate is above your critical threshold of 8888')
        expect(chef_run).to render_file(agent_config).with_content('receive rate is above your warning threshold of 7777')
        expect(chef_run).to render_file(agent_config).with_content('receive rate is above your critical threshold of 6666')
      end
    end
  end

  context 'Disk check' do
    context 'rackspace_monitoring_check for disk' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::disk')
      end
      it_behaves_like 'agent config', 'agent.disk', 'agent.disk.xda1'
    end
    context 'rackspace_monitoring_check for disk with missing target attribute' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.disk'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
          node.set['rackspace_monitoring_check_test']['alarm_criteria'] = 'An agent.disk alarm criteria'
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'creates a config for each detected target' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.disk.sda1.yaml').with_content('target: /dev/sda1')
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.disk.sda5.yaml').with_content('target: /dev/sda5')
      end
      it 'creates an alarm criteria' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.disk.sda1.yaml').with_content('An agent.disk alarm criteria')
      end
    end
    context 'rackspace_monitoring_check for disk with a target but without an alarm criteria' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.disk'
          node.set['rackspace_monitoring_check_test']['target'] = 'fake_target'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'raises an error' do
        expect { chef_run }.to raise_error(RuntimeError)
      end
    end
    context 'rackspace_monitoring_check for disk with target discovery and without an alarm criteria' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.disk'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'disables alarm' do
        expect(chef_run).to_not render_file('/etc/rackspace-monitoring-agent.conf.d/agent.disk.sda1.yaml').with_content('alarms')
        expect(chef_run).to_not render_file('/etc/rackspace-monitoring-agent.conf.d/agent.disk.sda5.yaml').with_content('alarms')
      end
    end
  end

  context 'Filesystem check' do
    context 'rackspace_monitoring_check for filesystem' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::filesystem')
      end
      it_behaves_like 'agent config', 'agent.filesystem', 'agent.filesystem.var'
    end
    context 'rackspace_monitoring_check with missing target attribute' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.filesystem'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'creates a config for each detected target' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.filesystem.slash.yaml').with_content('target: /')
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.filesystem.boot.yaml').with_content('target: /boot')
      end
    end
    context 'rackspace_monitoring_check with custom target' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.filesystem'
          node.set['rackspace_monitoring_check_test']['target'] = 'dummy_target'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'configures the agent.yaml with the correct target' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.filesystem.dummy_target.yaml').with_content('target: dummy_target')
      end
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.filesystem.dummy_target.yaml'
        expect(chef_run).to render_file(agent_config).with_content("percentage(metric['used'], metric['total']) > 95")
        expect(chef_run).to render_file(agent_config).with_content("percentage(metric['used'], metric['total']) > 90")
        expect(chef_run).to render_file(agent_config).with_content('Disk usage is above 95%, #{used} out of #{total}')
        expect(chef_run).to render_file(agent_config).with_content('Disk usage is above 90%, #{used} out of #{total}')
        expect(chef_run).to render_file(agent_config).with_content('Disk usage is below your warning threshold of 90%, #{used} out of #{total}')
      end
    end
  end

  context 'Plugin check' do
    context 'rackspace_monitoring_check' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::plugin')
      end
      it 'creates the plugin directory' do
        expect(chef_run).to create_directory('/usr/lib/rackspace-monitoring-agent/plugins')
      end
      it 'downloads the plugin awesome_plugin.py from rackspace_monitoring_check_test::plugin' do
        expect(chef_run).to create_remote_file('/usr/lib/rackspace-monitoring-agent/plugins/awesome_plugin.py')
      end
      it_behaves_like 'agent config', 'agent.plugin'
    end
    context 'rackspace_monitoring_check with missing mandatory attribute' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.plugin'
          node.set['rackspace_monitoring_check_test']['alarm'] = true
        end.converge('rackspace_monitoring_check_test::default')
      end
      it_behaves_like 'raise error about missing parameters'
    end
    context 'rackspace_monitoring_check with plugin_url and args' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.plugin'
          node.set['rackspace_monitoring_check_test']['plugin_url'] = 'http://www.dummyhot.com/dummyplugin.py'
          node.set['rackspace_monitoring_check_test']['plugin_args'] = ['--dummyargs']
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'downloads the plugin(with a filename based on the url)' do
        expect(chef_run).to create_remote_file('/usr/lib/rackspace-monitoring-agent/plugins/dummyplugin.py')
      end
      it 'configures the agent.yaml with the correct plugin' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.plugin.yaml').with_content('file: dummyplugin.py')
      end
      it 'configures the agent.yaml and passes the args' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.plugin.yaml').with_content('args: ["--dummyargs"]')
      end
    end
    context 'rackspace_monitoring_check with plugin_url and plugin_filename' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_CHECK_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring_check_test']['type'] = 'agent.plugin'
          node.set['rackspace_monitoring_check_test']['plugin_url'] = 'http://www.dummyhot.com/dummyplugin.py'
          node.set['rackspace_monitoring_check_test']['plugin_filename'] = 'dummy_filename.py'
        end.converge('rackspace_monitoring_check_test::default')
      end
      it 'configures the agent.yaml and set the plugin_filename according to :plugin_filename' do
        expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.plugin.yaml').with_content('file: dummy_filename.py')
      end
      it 'downloads the plugin(with a filename based on :plugin_filename)' do
        expect(chef_run).to create_remote_file('/usr/lib/rackspace-monitoring-agent/plugins/dummy_filename.py')
      end
    end
  end

  context 'Apache check' do
    context 'rackspace_monitoring_check for Apache' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(CENTOS_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::apache')
      end
      it_behaves_like 'agent config', 'agent.apache'
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.apache.yaml'
      end
    end
  end

  context 'MySQL check' do
    context 'rackspace_monitoring_check for MySQL' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(CENTOS_CHECK_OPTS) do |node|
          node_resources(node)
        end.converge('rackspace_monitoring_check_test::mysql')
      end
      it_behaves_like 'agent config', 'agent.mysql'
      it 'creates default alarms' do
        agent_config = '/etc/rackspace-monitoring-agent.conf.d/agent.mysql.yaml'
      end
    end
  end
end
