name             'centos_cloud'
maintainer       'cloudtechlab'
maintainer_email 'laboshinl@gmail.com'
license          'Do What The Fuck You Want To Public License, Version 2'
description      'Installs/Configures openstack cloudstructure based on CentOS 7.0'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.1'

depends  "firewalld", ">=0.2.4"
depends  "libcloud",">=0.1.0"
depends  "lvm",">=1.2.2"

supports "centos", ">= 7.0"

