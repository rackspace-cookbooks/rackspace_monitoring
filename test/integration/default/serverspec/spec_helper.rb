# Encoding: utf-8
# frozen_string_literal: true
require 'serverspec'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/bin:/bin'
  end
end
