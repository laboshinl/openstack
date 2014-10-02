#!/usr/bin/env bats

@test "keystone binary is found in PATH" {
  run which keystone
  [ "$status" -eq 0 ]
}