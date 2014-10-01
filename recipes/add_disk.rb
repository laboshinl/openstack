#
# Cookbook Name:: centos_cloud
# Recipe:: add_disk
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

#For use with vagrant test-kitchen, adds sdb to main VolGroup

bash "add disk" do
  code <<-CODE
set -e
set -x
  
if [ -f /etc/disk_added_date ]
then
   echo "disk already added so exiting."
   exit 0
fi
  
pvcreate /dev/sdb
vgextend #{node[:auto][:volume_group]} /dev/sdb
  
date > /etc/disk_added_date
CODE
end