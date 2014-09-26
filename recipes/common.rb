#
# Cookbook Name:: centos_cloud
# Recipe:: common
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::selinux"
include_recipe "centos_cloud::repos"
include_recipe "firewalld"
include_recipe "libcloud::ssh_key"
include_recipe "centos_cloud::ntp"

%w[bash-completion].each do |pkg|
  package pkg do
    action :install
  end
end

libcloud_ssh_keys "openstack" do
  data_bag "ssh_keypairs"
  action [:create, :add]
end

service "NetworkManager" do 
  action [:stop, :disable]
end

#libcloud_file_append "/etc/sysctl.conf" do
#  line [
#    "net.ipv6.conf.all.disable_ipv6=1",
#    "net.ipv6.conf.default.disable_ipv6=1"]
#end

#execute "sysctl -p"

libcloud_file_append "/root/.bashrc" do
  line [
    "# Keystone credentials generated by chef",
    "export OS_USERNAME=admin",
    "export OS_TENANT_NAME=admin",
    "export OS_PASSWORD=#{node[:creds][:admin_password]}",
    "export OS_AUTH_URL=http://#{node[:ip][:keystone]}:35357/v2.0/"]
end

