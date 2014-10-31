#!/usr/bin/env bats

@test "keystone admin port is open" {
  run firewall-cmd --list-services --permanent --zone=internal 
  [[ ${output} =~ "openstack-keystone-admin" ]]
}

@test "keystone public port is open" {
  run firewall-cmd --list-services --permanent --zone=public
  [[ ${output} =~ "openstack-keystone-public" ]]
}