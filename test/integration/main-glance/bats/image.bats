#!/usr/bin/env bats

upload_image(){
  source /root/.bashrc
  glance image-create --name cirros-0.3.3-x86_64 --copy-from http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img --disk-format qcow2 --container-format bare --is-public True --id 4ffba29b-03b7-4505-800c-dd8d1c8dc1a4
}

get_image(){
  source /root/.bashrc
  glance image-show 4ffba29b-03b7-4505-800c-dd8d1c8dc1a4 | grep status | grep $1
}

destroy_image()
  source /root/.bashrc
  glance image-delete 4ffba29b-03b7-4505-800c-dd8d1c8dc1a4
}

@test "upload test image" {
  run upload_image
  [ "$status" -eq 0 ]
}

@test "verify image" {
  run get_image created
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