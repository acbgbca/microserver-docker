#!/bin/bash
set -euo pipefail

wd=${1:-/mnt/ssd512/ctr_cfg}
date=`date "+%Y%m%d"`

bd=${2:-/tmp/backup}
bd=$bd/$date

# Create a directory for today
mkdir -p $bd
su -c "mkdir -p /mnt/backup/$date/" ctrdata

echo "Working Directory: $wd"
echo "Backup Directory: $bd"

cd $wd

su -c "git pull --ff-only origin main" devops
# tag with todays date to make rollback easier
su -c "git tag -a $date -m 'Version $date' && git push origin $date" devops

# Before we start, clean up the plex cache
# This removes all cache files older than 5 days
find "./plex/config/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder" -type f -mtime +5 -delete

set +e
for d in */ ; do
	# Remove trailing slash from directory
	d=${d%/}
	cd $d
	if [ -f ".no_upgrade" ]; then
		echo "Skipping $d. Pull only"
		docker compose pull -q
		echo "Skipping $d. Pull complete"
		cd ..
		continue
	fi
	(
		set -e
		echo "Backing up $d"
		docker compose down
		if [ $d = "plex" ]
		then
			# Exclude paths not required for restore
			tar --exclude='config/Library/Application Support/Plex Media Server/Cache' --exclude='config/Library/Application Support/Plex Media Server/Crash Reports' --exclude='config/Library/Application Support/Plex Media Server/Logs' --exclude='config/Library/Application Support/Plex Media Server/Media' -czf $bd/$d.tgz ../$d
		else
			tar -czf $bd/$d.tgz ../$d
		fi
		su -c "cp $bd/$d.tgz /mnt/backup/$date/" ctrdata

		echo "Upgrading $d"
		docker compose pull -q

		docker compose up -d --remove-orphans
	)
	result=$?
	if [ $result -ne 0 ] ; then
		echo "Error upgrading $d";
	else
		echo "$d upgraded successfully";
	fi
	
	cd ..
done
set -e

# Remove old images
docker image prune -fa

rm $bd/*.tgz

rmdir $bd
