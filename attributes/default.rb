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
  result = nil
  for iface in node[:network][:interfaces].keys.sort 
    if node[:network][:interfaces][iface.to_sym][:addresses].has_key?(address.to_sym)
       result = iface
       break
    end
  end
  result
end

def get_netmask(address)
  result = nil
  for key in node[:network][:interfaces].keys.sort
    if node[:network][:interfaces][key.to_sym][:addresses].has_key?(address.to_sym)
       result = node[:network][:interfaces][key][:addresses][address][:netmask]
       break
    end
  end
  result
end

default[:openstack_release] = "icehouse"

#Switch to 'qemu' when testing on VM's
if (node[:virtualization].attribute?(:role) and
     node[:virtualization][:role]=="guest")
  default[:libvirt][:type] = "qemu"
else 
  default[:libvirt][:type] = "kvm"
end

#<> Volume group will be used by cinder 
default[:auto][:volume_group] = largest_vg
#<> IP address in external network 
default[:auto][:external_ip]  = node[:ipaddress]
#<> IP address in external network 
default[:auto][:internal_ip]  = internal_ipv4
#<> External network interface
default[:auto][:external_nic] = get_iface(node[:auto][:external_ip])
#<> Internal network interface
default[:auto][:internal_nic] = get_iface(node[:auto][:internal_ip])
#<> Default gateway
default[:auto][:gateway] = node[:network][:default_gateway]
#<> External subnet's netmask
default[:auto][:netmask] = get_netmask(node[:auto][:external_ip])

#<> Cloud administrator's password
default[:creds][:admin_password]    = "cl0udAdmin"
#<> Database admin's password
default[:creds][:mysql_password]    = node[:creds][:admin_password]
#<> Rabbutmq guest's password
default[:creds][:rabbitmq_password] = node[:creds][:admin_password]
#<> Keystone auth token
default[:creds][:keystone_token]    = node[:creds][:admin_password]
#<> Swift shared secret
default[:creds][:swift_hash]        = node[:creds][:admin_password]
#<> Neutron shared secret
default[:creds][:neutron_secret]    = node[:creds][:admin_password]
#<> Ceilometer shared secret
default[:creds][:metering_secret]   = node[:creds][:admin_password]
#<> ssh keypair to use
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
  

