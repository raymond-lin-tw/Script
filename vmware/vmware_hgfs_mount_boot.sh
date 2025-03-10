#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Exiting."
    exit 1
fi


FILE_PATH="/etc/systemd/system/mnt-hgfs.mount"

cat <<EOF > $FILE_PATH
[Unit]
Description=VMware mount for hgfs
DefaultDependencies=no
Before=umount.target
ConditionVirtualization=vmware
After=sys-fs-fuse-connections.mount

[Mount]
What=vmhgfs-fuse
Where=/mnt/hgfs
Type=fuse
Options=default_permissions,allow_other,uid=1000,gid=1000

[Install]
WantedBy=multi-user.target
EOF

echo "File '$FILE_PATH' has been created successfully."

sudo systemctl daemon-reload
sudo systemctl enable mnt-hgfs.mount
sudo systemctl start mnt-hgfs.mount

