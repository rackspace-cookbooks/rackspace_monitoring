# Encoding: utf-8
# frozen_string_literal: true

name 'rackspace_monitoring'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace_monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.3'

issues_url 'https://github.com/rackspace-cookbooks/rackspace_monitoring/issues' if respond_to?(:issues_url)
source_url 'https://github.com/rackspace-cookbooks/rackspace_monitoring' if respond_to?(:source_url)
chef_version '>= 12' if respond_to?(:chef_version)

depends 'apt'
depends 'yum'

supports 'ubuntu'
