# Description

Installs/Configures openstack cloudstructure based on CentOS 7.0

# Requirements

## Platform:

* Centos (>= 7.0)

## Cookbooks:

* firewalld (>= 0.2.4)
* libcloud (>= 0.1.0)
* lvm (>= 1.2.2)

# Attributes

* `node[:openstack_release]` -  Defaults to `"icehouse"`.
* `node[:libvirt][:type]` -  Defaults to `"kvm"`.
* `node[:auto][:volume_group]` - Volume group will be used by cinder. Defaults to `"largest_vg"`.
* `node[:auto][:external_ip]` -  Defaults to `"node[:ipaddress]"`.
* `node[:auto][:internal_ip]` -  Defaults to `"internal_ipv4"`.
* `node[:auto][:external_nic]` -  Defaults to `"get_iface(node[:auto][:external_ip])"`.
* `node[:auto][:internal_nic]` -  Defaults to `"get_iface(node[:auto][:internal_ip])"`.
* `node[:auto][:gateway]` -  Defaults to `"node[:network][:default_gateway]"`.
* `node[:auto][:netmask]` -  Defaults to `"get_netmask(node[:auto][:external_ip])"`.
* `node[:creds][:admin_password]` -  Defaults to `"cl0udAdmin"`.
* `node[:creds][:mysql_password]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:rabbitmq_password]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:keystone_token]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:swift_hash]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:neutron_secret]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:metering_secret]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:ssh_keypair]` -  Defaults to `"node[:creds][:admin_password]"`.
* `node[:ip][:controller]` -  Defaults to `"node[:auto][:internal_ip]"`.
* `node[:ip_ex][:controller]` -  Defaults to `"node[:auto][:external_ip]"`.
* `node[:ip][:rabbitmq]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip][:keystone]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:keystone]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:swift]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:swift]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:glance]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:glance]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:cinder]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:cinder]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:neutron]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:neutron]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:nova]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:nova]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:heat]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:heat]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:ceilometer]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:ceilometer]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:sahara]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:ip_ex][:sahara]` -  Defaults to `"node[:ip_ex][:controller]"`.
* `node[:ip][:monitoring]` -  Defaults to `"node[:ip][:controller]"`.
* `node[:odl][:ram]` -  Defaults to `"1G"`.

# Recipes

* centos_cloud::add_disk
* centos_cloud::ceilometer
* centos_cloud::ceph
* centos_cloud::cinder
* [centos_cloud::common](#centos_cloudcommon) - This recipe produces some common for all nodes initial configuration.
* centos_cloud::controller
* centos_cloud::dashboard
* centos_cloud::default
* [centos_cloud::firewall](#centos_cloudfirewall) - The recipe defines openstack-related firewalld services.
* centos_cloud::glance
* centos_cloud::gluster
* centos_cloud::heat
* centos_cloud::keystone
* centos_cloud::mysql
* centos_cloud::neutron
* centos_cloud::node
* centos_cloud::nova-compute
* centos_cloud::nova
* centos_cloud::ntp
* centos_cloud::opendaylight
* centos_cloud::openvswitch
* centos_cloud::rabbitmq-server
* centos_cloud::repos
* centos_cloud::sahara
* [centos_cloud::selinux](#centos_cloudselinux) - The recipe disables selinux.
* centos_cloud::swift-node
* centos_cloud::swift-proxy

## centos_cloud::common

This recipe produces some common for all nodes initial configuration.

- Call [selinux recipe](#centos_cloudselinux) to disable selinux;
- Call repos recipe to configure repositories;
- Call firewalld resipe to define additional services;
- Call ntp recipe to setup time synchronisation;
- Install some usefull tools;
- Copy private ssh key to `id_rsa` & add public key to `authorized_keys`;
- Disable NetworkManager
- Disable IPv6;
- Write openstack credential to root's `.bashrc`;

## centos_cloud::firewall

The recipe defines openstack-related firewalld services. It also adds external and internal interfaces to 'public' and 'internal' zones rescectively.

## centos_cloud::selinux

The recipe disables selinux. It disables selinux in config and executes 'setenforce 0'.

# Resources

* [centos_cloud_config](#centos_cloud_config)
* [centos_cloud_database](#centos_cloud_database)
* [centos_cloud_scp_file](#centos_cloud_scp_file)
* [centos_cloud_ssh_command](#centos_cloud_ssh_command)
* [centos_cloud_ssh_key_manage](#centos_cloud_ssh_key_manage)

## centos_cloud_config

### Actions

- set:

### Attribute Parameters

- file:
- command:

## centos_cloud_database

### Actions

- create:

### Attribute Parameters

- name:
- password:

## centos_cloud_scp_file

### Actions

- set:

### Attribute Parameters

- file:
- command:

## centos_cloud_ssh_command

### Actions

- set:

### Attribute Parameters

- file:
- command:

## centos_cloud_ssh_key_manage

### Actions

- add:

### Attribute Parameters

- item:
- databag:  Defaults to <code>"ssh_keypairs"</code>.

# License and Maintainer

Maintainer:: cloudtechlab (<laboshinl@gmail.com>)

License:: Do What The Fuck You Want To Public License, Version 2
