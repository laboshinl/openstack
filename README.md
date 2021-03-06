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
* `node[:auto][:external_ip]` - IP address in external network. Defaults to `"node[:ipaddress]"`.
* `node[:auto][:internal_ip]` - IP address in external network. Defaults to `"internal_ipv4"`.
* `node[:auto][:external_nic]` - External network interface. Defaults to `"get_iface(node[:auto][:external_ip])"`.
* `node[:auto][:internal_nic]` - Internal network interface. Defaults to `"get_iface(node[:auto][:internal_ip])"`.
* `node[:auto][:gateway]` - Default gateway. Defaults to `"node[:network][:default_gateway]"`.
* `node[:auto][:netmask]` - External subnet's netmask. Defaults to `"get_netmask(node[:auto][:external_ip])"`.
* `node[:creds][:admin_password]` - Cloud administrator's password. Defaults to `"cl0udAdmin"`.
* `node[:creds][:mysql_password]` - Database admin's password. Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:rabbitmq_password]` - Rabbutmq guest's password. Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:keystone_token]` - Keystone auth token. Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:swift_hash]` - Swift shared secret. Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:neutron_secret]` - Neutron shared secret. Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:metering_secret]` - Ceilometer shared secret. Defaults to `"node[:creds][:admin_password]"`.
* `node[:creds][:ssh_keypair]` - ssh keypair to use. Defaults to `"node[:creds][:admin_password]"`.
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

# Recipes

* centos_cloud::add_disk
* [centos_cloud::ceilometer](#centos_cloudceilometer)
* centos_cloud::ceph
* [centos_cloud::cinder](#centos_cloudcinder)
* [centos_cloud::common](#centos_cloudcommon) - This recipe produces some initial configuration.
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
* [centos_cloud::ntp](#centos_cloudntp) - This recipe configures secured ntp client.
* centos_cloud::opendaylight
* centos_cloud::openvswitch
* centos_cloud::rabbitmq-server
* centos_cloud::repos
* centos_cloud::sahara
* [centos_cloud::selinux](#centos_cloudselinux) - The recipe disables selinux.
* centos_cloud::swift-node
* [centos_cloud::swift-proxy](#centos_cloudswift-proxy)

## centos_cloud::ceilometer

This recipe installs and configures openstack metering service

[x] Install mongodb-server <br>
Create ceilometer database <br>
Install ceilometer packages <br>
Configure ceilometer <br>
Populate ceilometer database <br>
Accept ceilometer ports <br>

## centos_cloud::cinder

This recipe installs and configures openstack block storage

- [x] Create database for cinder
- [x] Install cinder packages
- [x] Enable services
- Fix [bug](https://bugs.launchpad.net/cinder/+bug/1300136)
- [x] Configure services
- [x] Populate cinder database
- [x] Accept incoming connections on cinder ports

## centos_cloud::common

This recipe produces some initial configuration.

- Call [selinux](#centos_cloudselinux) recipe to disable selinux;
- Call [repos](#centos_cloudrepos) recipe recipe to configure repositories;
- Call [firewall](#centos_cloudfirewall) recipe to define additional services;
- Call [ntp](#centos_cloudfirewall) recipe to setup time synchronisation;
- [x] Install some usefull tools;
- [x] Copy private ssh key to `id_rsa` & add public key to `authorized_keys`;
- [x] <del>Disable NetworkManager</del>
- [x] Disable IPv6;
- [x] Write openstack credentials to root's `.bashrc`;

## centos_cloud::firewall

The recipe defines openstack-related firewalld services. It also adds external and internal interfaces to 'public' and 'internal' zones rescectively.

## centos_cloud::ntp

This recipe configures secured ntp client.

## centos_cloud::selinux

The recipe disables selinux. It disables selinux in config and executes 'setenforce 0'.

## centos_cloud::swift-proxy

This recipe installs and configures openstack-swift-proxy
<br> Install swift-proxy packages
<br> Configure proxy-server
<br> Create object, container and account builders
<br> Accept swift-proxy ports

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

# How to use


# License and Maintainer

Maintainer:: cloudtechlab (<laboshinl@gmail.com>)

License:: Do What The Fuck You Want To Public License, Version 2
