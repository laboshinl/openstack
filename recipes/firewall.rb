#
# Cookbook Name:: centos_cloud
# Recipe:: firewall
#
=begin
#<
The recipe defines openstack-related firewalld services. It also adds external and internal interfaces to 'public' and 'internal' zones rescectively.
#>
=end
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

%w[
iscsi.xml                      openstack-heat-api.xml         openstack-nova-api.xml
ntp.xml                        openstack-heat-cfn-api.xml     openstack-novncproxy.xml
openstack-cinder.xml           openstack-keystone-admin.xml   rabbitmq.xml
openstack-glance-api.xml       openstack-keystone-public.xml  vncdisplay.xml
openstack-glance-registry.xml  openstack-neutron-server.xml   openstack-ceilometer-api.xml
].each do |tmp|
  template "/etc/firewalld/services/#{tmp}" do
    owner "root"
    group "root"
    mode "0644"
    source "firewall/#{tmp}"
  end
end

execute "add internal interface to internal zone" do 
  command "firewall-cmd --permanent --zone=internal --add-interface=#{node[:auto][:internal_nic]}"
  action :run
  notifies :restart, "service[firewalld]"
end

execute "add external interface to public zone" do
  command "firewall-cmd --permanent --zone=public --add-interface=#{node[:auto][:external_nic]}"
  action :run
  notifies :restart, "service[firewalld]"
end

service "firewalld" do
  action :restart
end
