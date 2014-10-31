#
# Cookbook Name:: centos_cloud
# Recipe:: nova
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::mysql"
include_recipe "centos_cloud::dashboard"

centos_cloud_database "nova" do
  password node[:creds][:mysql_password]
end

%w[
  openstack-nova-api 
  openstack-nova-scheduler
  openstack-nova-conductor 
  openstack-nova-console
  openstack-nova-cert 
  openstack-nova-novncproxy
].each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/init.d/openstack-nova-consoleauth" do
  mode "0755"
  owner "root"
  group "root"
  source "nova/openstack-nova-consoleauth.erb"
end

%w[
  openstack-nova-api 
  openstack-nova-scheduler
  openstack-nova-conductor 
  openstack-nova-console
  openstack-nova-cert 
  openstack-nova-novncproxy
  openstack-nova-consoleauth
].each do |srv|
  service srv do
    action [:enable]
  end
end

template "/etc/nova/nova.conf" do
  mode   "0644"
  owner  "root"
  group  "root"
  source "nova/nova.conf.erb"
  notifies :run, "execute[Populate nova database]"
end

execute "Populate nova database" do 
  command %Q[su nova -s /bin/sh -c "/usr/bin/nova-manage db sync"]
  action :nothing
  notifies :restart, "service[openstack-nova-scheduler]"
  notifies :restart, "service[openstack-nova-conductor]"
  notifies :restart, "service[openstack-nova-cert]"
  notifies :restart, "service[openstack-nova-console]"
  notifies :restart, "service[openstack-nova-consoleauth]"
  notifies :restart, "service[openstack-nova-api]"
  notifies :restart, "service[openstack-nova-cert]"
  notifies :restart, "service[openstack-nova-novncproxy]"
end

firewalld_rule "openstack-nova" do
  action :set
  zone "public"
  service %w[openstack-nova-api openstack-novncproxy]
end

firewalld_rule "openstack-nova" do
  action :set
  zone "internal"
  service %w[openstack-nova-api openstack-novncproxy]
end