#
# Cookbook Name:: centos_cloud
# Recipe:: ceilometer
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "firewalld"

%w{
mariadb-galera-server 
MySQL-python
}.each  do |pkg|
  package pkg do
    action :install
  end
end

service "mariadb" do
  action [:enable]
end

template "/etc/my.cnf.d/server.cnf" do
  source "mariadb/server.cnf.erb"
  notifies :delete, "file[ib_logfile0]", :immediately 
  notifies :delete, "file[ib_logfile1]", :immediately
  notifies :restart, "service[mariadb]", :immediately
end

file "ib_logfile0" do
  path "/var/lib/mysql/ib_logfile0"
  action :nothing
end

file "ib_logfile1" do
  path "/var/lib/mysql/ib_logfile1"
  action :nothing
end

firewalld_rule "mysql" do
  action :set
  zone "internal"
  protocol "tcp"
  port "3306"
end

execute "Set mysql admin password" do
  command %Q[mysqladmin -uroot password "#{node[:creds][:mysql_password]}" || : ]
  #ignore_failure true 
  action :run
end
