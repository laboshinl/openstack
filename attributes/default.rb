require "socket"

#Helpers
def my_first_public_ipv4
  Socket.ip_address_list.detect{|intf| intf.ip_address == node[:ipaddress]}
end

def my_first_private_ipv4
  Socket.ip_address_list.detect{|intf| !intf.ipv4_loopback? and intf.ip_address!=node[:ipaddress]}
end

def internal_ipv4
  my_first_private_ipv4.nil? ? my_first_public_ipv4.ip_address : my_first_private_ipv4.ip_address
end

def largest_vg 
  vg = Mixlib::ShellOut.new("vgs --sort -size --rows | grep VG -m 1 | awk '{print $2}'")
  vg.run_command
  vg.error!
  return vg.stdout[0..-2]
end

def get_iface(address)
  node[:network][:interfaces].each do |iface|
    if !iface[1]["addresses"][address].nil?
       return iface[0]
    end
  end
end

def get_netmask(address)
  node[:network][:interfaces].each do |iface|
    if !iface[1]["addresses"][address].nil?
       return iface[1]["addresses"][address]["netmask"]
    end
  end
end

default[:openstack_release] = "icehouse"

#Switch to 'qemu' when testing on VM's
if (node[:virtualization].attribute?(:role) and
     node[:virtualization][:role]=="guest")
  default[:libvirt][:type] = "qemu"
else 
  default[:libvirt][:type] = "kvm"
end

#Automatic attributes 
default[:auto][:volume_group] = largest_vg
default[:auto][:external_ip]  = node[:ipaddress]
default[:auto][:internal_ip]  = internal_ipv4
default[:auto][:external_nic] = get_iface(node[:auto][:external_ip])
default[:auto][:internal_nic] = get_iface(node[:auto][:internal_ip])
default[:auto][:gateway] = node[:network][:default_gateway]
default[:auto][:netmask] = get_netmask(node[:auto][:external_ip])
  
#Credentials
default[:creds][:admin_password]    = "cl0udAdmin"
default[:creds][:mysql_password]    = node[:creds][:admin_password]
default[:creds][:rabbitmq_password] = node[:creds][:admin_password]
default[:creds][:keystone_token]    = node[:creds][:admin_password]
default[:creds][:swift_hash]        = node[:creds][:admin_password]
default[:creds][:neutron_secret]    = node[:creds][:admin_password]
default[:creds][:metering_secret]   = node[:creds][:admin_password]
default[:creds][:ssh_keypair]       = node[:creds][:admin_password]

#IP addresses
default[:ip][:controller]     = node[:auto][:internal_ip]
default[:ip_ex][:controller]  = node[:auto][:external_ip]
default[:ip][:rabbitmq]       = node[:ip][:controller]
default[:ip][:keystone]       = node[:ip][:controller]
default[:ip_ex][:keystone]    = node[:ip_ex][:controller]
default[:ip][:swift]          = node[:ip][:controller]
default[:ip_ex][:swift]       = node[:ip_ex][:controller] 
default[:ip][:glance]         = node[:ip][:controller]
default[:ip_ex][:glance]      = node[:ip_ex][:controller]
default[:ip][:cinder]         = node[:ip][:controller]
default[:ip_ex][:cinder]      = node[:ip_ex][:controller]  
default[:ip][:neutron]        = node[:ip][:controller]
default[:ip_ex][:neutron]     = node[:ip_ex][:controller] 
default[:ip][:nova]           = node[:ip][:controller]
default[:ip_ex][:nova]        = node[:ip_ex][:controller] 
default[:ip][:heat]           = node[:ip][:controller]
default[:ip_ex][:heat]        = node[:ip_ex][:controller] 
default[:ip][:ceilometer]     = node[:ip][:controller]
default[:ip_ex][:ceilometer]  = node[:ip_ex][:controller]
default[:ip][:sahara]         = node[:ip][:controller]
default[:ip_ex][:sahara]      = node[:ip_ex][:controller]
default[:ip][:monitoring]     = node[:ip][:controller]

#Opendaylight RAM
default[:odl][:ram]="1G"
  

