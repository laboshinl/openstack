#!/usr/bin/env bats

@test "keystone public port is open" {
  run ntpstat 
  [[ ${output} =~ "synchronised" ]]
}