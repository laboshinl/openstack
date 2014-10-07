#!/usr/bin/env bats
UUID=00000000-0000-0000-0000-000000000000
#UUID=`uuidgen`

upload_image(){
  source /root/.bashrc
  glance image-create --name cirros-0.3.3-x86_64 --copy-from http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img --disk-format qcow2 --container-format bare --is-public True --id $UUID
}

get_image(){
  source /root/.bashrc
  glance image-show $UUID | grep status | grep $1
}

destroy_image(){
  source /root/.bashrc
  glance image-delete $UUID
}

@test "upload test image" {
  run upload_image
  [ "$status" -eq 0 ]
}

@test "verify image" {
  run sleep 10 && get_image active
  [ "$status" -eq 0 ]
}

@test "destroy image" {
  run destroy_image
  [ "$status" -eq 0 ]
}

@test "verify image deleted" {
  run get_image deleted 
  [ "$status" -eq 0 ]
}