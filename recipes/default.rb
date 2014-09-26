#
# Cookbook Name:: centos_cloud
# Recipe:: default
#
# Copyright © 2014 Leonid Laboshin <laboshinl@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

#include_recipe "centos_cloud::controller"
#include_recipe "centos_cloud::node"
include_recipe "centos_cloud::keystone"