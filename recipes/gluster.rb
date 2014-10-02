include_recipe "centos_cloud::common"

package "glusterfs-server" do
  action :install
end

service "glusterd" do
  action [:enable, :start]
end

firewalld_rule "gluster" do
  action :set
  protocol "tcp"
  port %w[2049 111 24007-24047 38465-38467]
end

#execute "gluster peer probe node[:nova][:ip]"
=begin
firewalld_rule "glance" do
  action :set
  protocol "udp"
  port %w[111]
end
=end