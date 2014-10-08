#
# Cookbook Name:: centos_cloud
# Recipe:: cinder
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::mysql"

# Create database for cinder
centos_cloud_database "cinder" do
  password node[:creds][:mysql_password]
end

# Install cinder packages
%w[
  iscsi-initiator-utils
  openstack-cinder
  targetcli
].each do |pkg|
  package pkg do
    action :install
  end
end

service "target" do
  action [:enable, :start] 
end

%w[
  openstack-cinder-volume
  openstack-cinder-scheduler 
  openstack-cinder-api
].each do |srv|
  service srv do
    action [:enable]
  end
end 

# Configure service
template "/etc/cinder/cinder.conf" do
 source "cinder/cinder.conf.erb"
 notifies :run, "execute[Populate cinder database]"
end

template "/etc/cinder/api-paste.ini" do
 source "cinder/api-paste.ini.erb"
 notifies :restart, "service[openstack-cinder-api]"
end

# Populate database
execute "Populate cinder database" do 
  command "cinder-manage db sync"
  notifies :restart, "service[openstack-cinder-volume]"
  notifies :restart, "service[openstack-cinder-scheduler]"
  notifies :restart, "service[openstack-cinder-api]"
  action :nothing
end

# Accept incoming connections on glance ports
firewalld_rule "cinder" do
  port %w[8776]
  zone "public"
end

firewalld_rule "cinder" do
  port %w[3260]
  zone "internal"
end
