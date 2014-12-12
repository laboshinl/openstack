#
# Cookbook Name:: centos_cloud
# Recipe:: ceilometer
=begin
#<
This recipe installs and configures openstack metering service
#>
=end
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::mysql"

#<> [x] Install mongodb-server <br>
%w[
  mongodb-server 
  mongodb 
].each do |pkg|
  package pkg do
    action :install
  end
end

service "mongod" do
  action [:enable,:start]
end

#<> Create ceilometer database <br>
execute "create ceilometer database" do
  ignore_failure true
  command %Q{mongo ceilometer --eval 'db.addUser("ceilometer",}<<
    %Q{"#{node[:creds][:mysql_password]}", false)'}
  action :run
end

#<> Install ceilometer packages <br>
%w[
  openstack-ceilometer-api 
  openstack-ceilometer-central
  openstack-ceilometer-collector
].each do |srv|
  package srv do
    action :install
  end
  service srv do
    action [:enable]
  end
end

#<> Configure ceilometer <br>
template "/etc/ceilometer/ceilometer.conf" do
  mode   "0640"
  owner  "root"
  group  "ceilometer"
  source "ceilometer/ceilometer.conf.erb"
  notifies :restart, "service[openstack-ceilometer-api]"
  notifies :restart, "service[openstack-ceilometer-central]"
  notifies :restart, "service[openstack-ceilometer-collector]"
end

#<> Populate ceilometer database <br>
execute "populate ceilometer database" do
  command "/usr/bin/ceilometer-dbsync"
  action :run
end

#<> Accept ceilometer ports <br>
firewalld_rule "openstack-ceilometer-api" do
  action :set
  zone "public"
  service "openstack-ceilometer-api"
end

firewalld_rule "openstack-ceilometer-api" do
  action :set
  zone "internal"
  service "openstack-ceilometer-api"
end
