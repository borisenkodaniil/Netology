#!/bin/bash
rsync -a --delete --checksum /home/daniil/Documents/projects/ daniil@192.168.122.241:/tmp/backup/

if [ $? -eq 0 ]; then
    logger -t backup_vm2 "Backup completed"
else
    logger -t backup_vm2 "Backup failed"
fi
