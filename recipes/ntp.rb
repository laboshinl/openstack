#
# Cookbook Name:: centos_cloud
# Recipe:: ntp-server
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

=begin
#<
This recipe configures secured ntp client.
#>
=end

package "ntp" do
    action :install
end

service "ntpd" do
 action :enable
end

firewalld_rule "ntp" do
  action :set
  zone "public"
  service "ntp"
end

template "/etc/ntp.conf" do
  source "ntp/ntp.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[ntpd]", :immediately 
end

template "/etc/ntp/step-tickers" do
  source "ntp/step-tickers.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[ntpd]"
end

