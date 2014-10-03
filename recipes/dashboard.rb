#
# Cookbook Name:: centos_cloud
# Recipe:: dashboard
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

include_recipe "libcloud::ssh_key"
include_recipe "centos_cloud::selinux"
include_recipe "centos_cloud::repos"
include_recipe "firewalld"

%w[
  httpd
  mod_wsgi 
  mod_ssl 
  openstack-dashboard
  memcached 
  python-memcached 
  python-django-sahara
].each do |pkg|
  package pkg do
    action :install
  end
end

service "httpd" do
  action [:enable,:start]
end
service "memcached" do
  action [:enable,:start]
end

firewalld_rule "dashboard" do
  action :set
  zone "public"
  protocol "tcp"
  port %w[443 80]
end

template "/usr/share/openstack-dashboard/openstack_dashboard/settings.py" do 
  mode "0644"
  owner "root"
  group "root"
  source "dashboard/settings.py.erb"
  notifies :restart, "service[httpd]"
end

template "/etc/openstack-dashboard/local_settings" do 
  mode "0640"
  owner "root"
  group "apache"
  source "dashboard/local_settings.erb"
  notifies :restart, "service[httpd]"
end

#BugFix
execute "sed -i 's/data_processing/data-processing/' /usr/lib/python2.7/site-packages/saharadashboard/api/client.py" do
action :run
end

#Redirect to /dashboard
cookbook_file "/var/www/html/index.html" do
  source "index.html"
  mode   "0644"
  owner  "root"
  group  "root"
  action :create_if_missing
  notifies :restart, "service[httpd]"
end

#Enforce https
template "/etc/httpd/conf.d/https.conf" do
  source "dashboard/https.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[httpd]"
end



