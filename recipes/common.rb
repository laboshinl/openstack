#
# Cookbook Name:: centos_cloud
# Recipe:: common
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

=begin
#<
This recipe produces some common for all nodes initial configuration.
#>
=end

#<> - Call selinux recipe to disable selinux;
include_recipe "centos_cloud::selinux"
#<> - Call repos recipe to configure repositories;
include_recipe "centos_cloud::repos"
# Include firewalld lwrp; 
include_recipe "firewalld"
#<> Call firewalld resipe to define additional services;
include_recipe "centos_cloud::firewall"
# Include ssh keys lwrp;
include_recipe "libcloud::ssh_key"
#<> Call ntp recipe to setup time synchronisation;
include_recipe "centos_cloud::ntp"

#<> Install some usefull tools;
%w[bash-completion python-openstackclient].each do |pkg|
  package pkg do
    action :install
  end
end

#<> Copy private ssh key to id_rsa & add public key to authorized_keys;
libcloud_ssh_keys "openstack" do
  data_bag "ssh_keypairs"
  action [:create, :add]
end

#<> Disable NetworkManager 
#service "NetworkManager" do 
#  action [:stop, :disable]
#end

#<> Disable IPv6;
libcloud_file_append "/etc/sysctl.conf" do
  line [
    "net.ipv6.conf.all.disable_ipv6=1",
    "net.ipv6.conf.default.disable_ipv6=1"]
  notifies :run, "execute[sysctl -p]"
end

execute "sysctl -p" do
  action :nothing
end

#<> Write openstack credential to root's .bashrc;
libcloud_file_append "/root/.bashrc" do
  line [
    "# Keystone credentials generated by chef",
    "export OS_USERNAME=admin",
    "export OS_TENANT_NAME=admin",
    "export OS_PASSWORD=#{node[:creds][:admin_password]}",
    "export OS_AUTH_URL=http://#{node[:ip_ex][:keystone]}:5000/v2.0/"]
end

