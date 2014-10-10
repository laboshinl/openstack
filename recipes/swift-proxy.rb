#
# Cookbook Name:: centos_cloud
# Recipe:: swift-proxy
#
=begin
#<> This recipe installs and configures openstack-swift-proxy 
=end
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.


include_recipe "centos_cloud::common"

#<> <br> Install swift-proxy packages
%w[
  memcached 
  openstack-swift-proxy
].each do |pkg|
  package pkg do
    action :install
  end
end

#<> <br> Configure proxy-server
template "/etc/swift/proxy-server.conf" do
  source "swift/proxy-server.conf.erb"
  owner "swift"
  group "swift"
  mode "0600"
  notifies :restart, "service[openstack-swift-proxy]"
end

template "/etc/swift/swift.conf" do
  source "swift/swift.conf.erb"
  notifies :restart, "service[openstack-swift-proxy]"
end

#<> <br> Create object, container and account builders
%w[object container account].each do |cmd|
  execute "swift-ring-builder "+ cmd +".builder create 10 1 1" do
    cwd "/etc/swift"
  end
end

directory "/tmp/keystone-signing-swift" do
  owner "swift"
  group "swift"
  mode "0755"
  action :create
end

# Start services
%w[
memcached 
openstack-swift-proxy
].each do |srv|
  service srv do
    action [:enable, :restart]
  end
end

#<> <br> Accept swift-proxy ports
firewalld_rule "swift-proxy" do
  action :set
  zone "public"
  service "openstack-swift-proxy"
end

firewalld_rule "swift-proxy" do
  action :set
  zone "internal"
  service "openstack-swift-proxy"
end

