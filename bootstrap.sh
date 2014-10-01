set -e
set -x

if [ -f /etc/disk_added_date ]
then
   echo "disk already added so exiting."
   exit 0
fi

VolGroup=$(vgs --sort -size --rows | grep VG -m 1 | awk '{print $2}')
pvcreate /dev/sdb
vgextend $VolGroup /dev/sdb

date > /etc/disk_added_date
