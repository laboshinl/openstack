#
# Cookbook Name:: centos_cloud
# Recipe:: ceph
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "centos_cloud::common"

package "ceph" do 
  action :install
end

template "/etc/ceph/ceph.conf" do
  owner "root"
  mode "0644"
  source "ceph/ceph.conf.erb"
end

firewalld_rule "ceph" do
  action :set
  protocol "tcp"
  port %w[6789]
end
