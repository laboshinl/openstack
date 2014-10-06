#
# Cookbook Name:: centos_cloud
# Recipe:: keystone
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::mysql"

# Open keystone-related ports
firewalld_rule "keystone" do
  action :set
  protocol "tcp"
  zone "internal"
  port %w[35357]
end

firewalld_rule "keystone" do
  action :set
  protocol "tcp"
  zone "public"
  port %w[5000]
end

# Install MySQL, create database
centos_cloud_database "keystone" do
  password node[:creds][:mysql_password]
end

# Install packages
%w[
  openstack-keystone 
  python-paste-deploy
].each do |pkg|
  package pkg do
    action :install
  end
end

service "openstack-keystone" do
  action [:enable]
end

# BUG_FIX: This file is nessesary for starting service
file "/var/log/keystone/keystone.log" do
  action :create
  owner "keystone"
  group "keystone"
  mode "0644"
end

# Template for creating services and endpoints
template "/etc/keystone/default_catalog.templates" do
  source "keystone/default_catalog.templates.erb"
  owner "root"
  group "keystone"
  mode "0640"
  notifies :restart, "service[openstack-keystone]"
end

template "/etc/keystone/keystone-paste.ini" do
  source "keystone/keystone-paste.ini.erb"
  owner "root"
  group "keystone"
  mode "0640"
  notifies :restart, "service[openstack-keystone]"
end  

# Configure service
template "/etc/keystone/keystone.conf" do
  mode "0640"
  owner "root"
  group "keystone"
  source "keystone/keystone.conf.erb"
  notifies :run, "execute[Populate keystone database]", :immediately
  notifies :restart, "service[openstack-keystone]", :immediately 
end

# Create dir for certs
directory "/etc/keystone/ssl" do
  owner "keystone"
  group "keystone"
  mode "0755"
  action :create
  notifies :run, "execute[Generate keystone certs]", :immediately
end

template "/etc/cron.daily/keystone.cron" do
  owner "root"
  group "root"
  mode "0755"
  source "keystone/keystone.cron.erb"
  action :create
end

execute "Populate keystone database" do
  command "su keystone -s /bin/sh -c 'keystone-manage db_sync'"
  action :nothing
end

execute "Generate keystone certs" do
  command "su keystone -s /bin/sh -c 'keystone-manage pki_setup'"
  action :nothing
end

# Wait for keystone to start
libcloud_api_wait node[:ip][:keystone] do
  port "35357"
end

# Configure users
[ "keystone bootstrap --pass #{node[:creds][:admin_password]} ||:",
  "keystone user-password-update admin --pass #{node[:creds][:admin_password]}",
  "keystone role-create --name Member || :",
  "keystone role-create --name ResellerAdmin || :",
  "keystone user-role-add --user admin --role-id ResellerAdmin --tenant-id admin || :"
].each do |cmd|
  execute cmd do
    environment({
      'OS_SERVICE_TOKEN' => node[:creds][:keystone_token],
      'OS_SERVICE_ENDPOINT' => 'http://' + node[:ip][:keystone] + ':35357/v2.0'
    })
    action :run
  end
end
