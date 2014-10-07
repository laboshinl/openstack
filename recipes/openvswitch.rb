#
# Cookbook Name:: centos_cloud
# Recipe:: openvswitch
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"

%w[
  openstack-neutron-openvswitch
  openstack-neutron-ml2 
  ].each do |pkg|
  package pkg do
    action :install
  end
end

%w[
  neutron-openvswitch-agent
  neutron-ovs-cleanup
].each do |srv| 
  service srv do
    action :enable
  end
end

service "openvswitch" do
    action [:enable, :start]
end 

service "network" do
  action :nothing
end

execute "ovs-vsctl --may-exist add-br br-int" do
  action :run
end

template "/etc/sysconfig/network-scripts/ifcfg-br-int" do
  owner "root"
  group "root"
  mode  "0644"
  source "neutron/ifcfg-br-int.erb"
  notifies :restart, "service[network]"
end
  
link "/etc/neutron/plugin.ini" do
  to "/etc/neutron/plugins/ml2/ml2_conf.ini"
  link_type :symbolic
end

uuid = Mixlib::ShellOut.new(%Q[/usr/bin/keystone ]<<
  %Q[--os-token #{node[:creds][:keystone_token]} ]<<
  %Q[--os-endpoint http://#{node[:ip][:keystone]}:35357/v2.0 ]<<
  %Q[tenant-list | grep admin | awk '{print $2}'])
uuid.run_command
uuid.error!
admin_id  = uuid.stdout[0..-2]

template "/etc/neutron/plugins/ml2/ml2_conf.ini" do
  mode "0640"
  owner "root"
  group "neutron"
  source "neutron/ml2_conf.ini.erb"  
  notifies :restart, "service[neutron-openvswitch-agent]"
end

template "/etc/neutron/neutron.conf" do
  mode "0640"
  owner "root"
  group "neutron"
  source "neutron/neutron.conf.erb"
  variables({
    :tenant_id => admin_id
  })
  notifies :restart, "service[neutron-openvswitch-agent]"
end

firewalld_rule "nova-compute" do
  action :set
  protocol "tcp"
  port %w[9696]
end

