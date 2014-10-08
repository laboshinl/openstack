%w[
iscsi.xml                      openstack-heat-api.xml         openstack-nova-api.xml
ntp.xml                        openstack-heat-cfn-api.xml     openstack-novncproxy.xml
openstack-cinder.xml           openstack-keystone-admin.xml   rabbitmq.xml
openstack-glance-api.xml       openstack-keystone-public.xml  vncdisplay.xml
openstack-glance-registry.xml  openstack-neutron-server.xml
].each do |tmp|
  template "/etc/firewalld/services/#{tmp}" do
    owner "root"
    group "root"
    mode "0644"
    source "firewall/#{tmp}"
  end
end

service "firewalld" do
  action :restart
end