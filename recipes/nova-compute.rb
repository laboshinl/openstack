#
# Cookbook Name:: centos_cloud
# Recipe:: nova-compute
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"
include_recipe "centos_cloud::openvswitch"

%w[openstack-nova-compute
openstack-ceilometer-compute
].each do |pkg|
  package pkg do
    action :install
  end
end

%w[openstack-nova-compute
openstack-ceilometer-compute
libvirtd
].each do |srv|
  service srv do
    action [:enable]
  end
end

template "/etc/libvirt/libvirtd.conf" do
  source "libvirt/libvirtd.conf.erb"
  owner "root"
  mode  "0644"
  group "root"
  notifies :restart, "service[libvirtd]"
  notifies :run,"execute[virsh net-destroy default ||:]"
  notifies :run,"execute[virsh net-undefine default ||:]"
end

template "/etc/sysconfig/libvirtd" do
  source "libvirt/libvirtd.erb"
  owner "root"
  mode  "0644"
  group "root"
  notifies :restart, "service[libvirtd]"
  notifies :run,"execute[virsh net-destroy default ||:]"
  notifies :run,"execute[virsh net-undefine default ||:]"
end

firewalld_rule "nova-compute" do
  action :set
  protocol "tcp"
  port %w[5900-5999 6080-6082]
end

firewalld_rule "libvirtd" do
  action :set
  protocol "tcp"
  port %w[49152-49216 16509]
end

template "/etc/nova/nova.conf" do
  mode   "0644"
  owner  "root"
  group  "root"
  source "nova/nova.conf.erb"
  notifies :restart, "service[openstack-nova-compute]"
end

template "/etc/ceilometer/ceilometer.conf" do
  mode   "0640"
  owner  "root"
  group  "ceilometer"
  source "ceilometer/ceilometer.conf.erb"
  notifies :restart, "service[openstack-ceilometer-compute]"
end

execute "virsh net-destroy default ||:" do
  action :nothing
end 

execute "virsh net-undefine default ||:" do
  action :nothing
end
