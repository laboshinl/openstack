#
# Cookbook Name:: centos_cloud
# Recipe:: glance
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::mysql"

# Create database
centos_cloud_database "glance" do
  password node[:creds][:mysql_password]
end

# Install packages
%w[
  openstack-glance 
  python-openstackclient
  python-pymongo-gridfs
].each do |pkg|
 package pkg
end

%w[
  openstack-glance-api 
  openstack-glance-registry
].each do |srv|
  service srv do
    action [:enable]
  end
end

file "/var/log/glance/registry.log" do
  action :create
  owner "glance"
  group "glance"
  mode "0644"
end

template "/etc/glance/glance-api.conf" do
  source "glance/glance-api.conf.erb"
  mode "0640"
  owner "root"
  group "glance"
  notifies :run, "execute[Populate glance database]"
end

template "/etc/glance/glance-registry.conf" do
  source "glance/glance-registry.conf.erb"
  mode "0640"
  owner "root"
  group "glance"
  notifies :run, "execute[Populate glance database]"
end

execute "Populate glance database" do
  command %Q[su glance -s /bin/sh -c ] <<
          %Q["/usr/bin/glance-manage db_sync"]
  action :nothing
  notifies :restart, "service[openstack-glance-registry]"
  notifies :restart, "service[openstack-glance-api]"
end

firewalld_rule "openstack-glance-api" do
  action :set
  zone "internal"
  service "openstack-glance-api"
end

firewalld_rule "openstack-glance-api" do
  action :set
  zone "public"
  service "openstack-glance-api"
end
