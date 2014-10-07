#
# Cookbook Name:: centos_cloud
# Recipe:: neutron
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::openvswitch"
include_recipe "centos_cloud::mysql"


centos_cloud_database "neutron" do
  password node[:creds][:mysql_password]
end

%w[
neutron-dhcp-agent
neutron-l3-agent
neutron-metadata-agent
neutron-lbaas-agent
neutron-server
network
].each do |srv|
  service srv do
    action [:enable]
  end
end

execute "ovs-vsctl --may-exist add-br br-ex" do
  action :run
end

template "/etc/sysconfig/network-scripts/ifcfg-#{node[:auto][:external_nic]}"  do
  owner "root"
  group "root"
  mode  "0644"
  source "neutron/ifcfg-ethX.erb"
  notifies :restart, "service[network]"
end

template "/etc/sysconfig/network-scripts/ifcfg-br-ex" do
  owner "root"
  group "root"
  mode  "0644"
  source "neutron/ifcfg-br-ex.erb"
  notifies :restart, "service[network]"
end

template "/etc/neutron/metadata_agent.ini" do
  source "neutron/metadata_agent.ini.erb"
  notifies :restart, "service[neutron-server]"
  notifies :restart, "service[neutron-metadata-agent]"
end

template "/etc/neutron/dhcp_agent.ini" do
  source "neutron/dhcp_agent.ini.erb"
  notifies :restart, "service[neutron-server]"
  notifies :restart, "service[neutron-dhcp-agent]"
end

template "/etc/neutron/lbaas_agent.ini" do
  source "neutron/lbaas_agent.ini.erb"
  notifies :restart, "service[neutron-server]"
  notifies :restart, "service[neutron-lbaas-agent]"
end

libcloud_file_append "/etc/neutron/dnsmasq-neutron.conf" do
  line ["dhcp-option-force=26,1454"]
end

template "/etc/neutron/l3_agent.ini" do
  source "neutron/l3_agent.ini.erb"
  notifies :restart, "service[neutron-server]"
  notifies :restart, "service[neutron-l3-agent]"
end

#Help with configuting public network
template "/root/floating-pool.sh" do
  source "neutron/floating-pool.erb"
  owner "root"
  group "root"
  mode "0744"
end

firewalld_rule "neutron" do
  action :set
  zone "internal"
  protocol "tcp"
  port %w[9696]
end

firewalld_rule "neutron" do
  action :set
  zone "public"
  protocol "tcp"
  port %w[9696]
end