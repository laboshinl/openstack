#!/usr/bin/env bats

@test "rabbit port is open" {
  run firewall-cmd --list-services --permanent --zone=internal 
  [[ ${output} =~ "rabbitmq" ]]
}