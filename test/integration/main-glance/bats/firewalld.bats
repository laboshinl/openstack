#!/usr/bin/env bats

@test "keystone admin port is open" {
  run firewall-cmd --list-services --permanent --zone=internal 
  [[ ${output} =~ "openstack-glance-api" ]]
}

@test "keystone public port is open" {
  run firewall-cmd --list-services --permanent --zone=public
  [[ ${output} =~ "openstack-glance-api" ]]
}