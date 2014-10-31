#
# Cookbook Name:: centos_cloud
# Recipe:: cinder
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

=begin
#<
 This recipe installs and configures openstack block storage
#>
=end

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::mysql"

#<> - [x] Create database for cinder
centos_cloud_database "cinder" do
  password node[:creds][:mysql_password]
end

#<> - [x] Install cinder packages
%w[
  iscsi-initiator-utils
  openstack-cinder
  targetcli
].each do |pkg|
  package pkg do
    action :install
  end
end

#<> - [x] Enable services
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

#<> - Fix [bug](https://bugs.launchpad.net/cinder/+bug/1300136)
cookbook_file "/usr/lib/python2.7/site-packages/cinder/volume/iscsi.py" do
  source "patch/iscsi.py"
  mode   "0644"
  owner  "root"
  group  "root"
end

#<> - Fix [bug](https://bugs.launchpad.net/cinder/+bug/1368527)
#cookbook_file "/usr/lib/python2.7/site-packages/cinder/openstack/common/strutils.py" do
#  source "patch/strutils.py"
#  mode   "0644"
#  owner  "root"
#  group  "root"
#end

#<> - [x] Configure services
template "/etc/cinder/cinder.conf" do
 source "cinder/cinder.conf.erb"
 notifies :run, "execute[Populate cinder database]"
end

template "/etc/cinder/api-paste.ini" do
 source "cinder/api-paste.ini.erb"
 notifies :restart, "service[openstack-cinder-api]"
end

#<> - [x] Populate cinder database
execute "Populate cinder database" do 
  command "cinder-manage db sync"
  notifies :restart, "service[openstack-cinder-volume]"
  notifies :restart, "service[openstack-cinder-scheduler]"
  notifies :restart, "service[openstack-cinder-api]"
  action :nothing
end

#<> - [x] Accept incoming connections on cinder ports
firewalld_rule "openstack-cinder" do
  service "openstack-cinder"
  zone "public"
end

firewalld_rule "openstack-cinder" do
  service "openstack-cinder"
  zone "internal"
end

firewalld_rule "iscsi" do
  service "iscsi"
  zone "internal"
end
