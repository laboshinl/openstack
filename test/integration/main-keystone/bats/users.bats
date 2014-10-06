#!/usr/bin/env bats

get_user(){
  source /root/.bashrc
  /usr/bin/keystone user-get $1
}

get_tenant(){
  source /root/.bashrc
  /usr/bin/keystone tenant-get $1
}

get_role(){
  source /root/.bashrc
  /usr/bin/keystone role-get $1
}

@test "keystone has user 'admin'" {
  run get_user admin
  [ "$status" -eq 0 ]
}

@test "keystone has tenant 'admin'" {
  run get_tenant admin
  [ "$status" -eq 0 ]
}

@test "keystone has role 'admin'" {
  run get_role admin
  [ "$status" -eq 0 ]
}

@test "keystone has role 'Member'" {
  run get_role Member
  [ "$status" -eq 0 ]
}

@test "keystone has role 'ResellerAdmin'" {
  run get_role ResellerAdmin
  [ "$status" -eq 0 ]
}