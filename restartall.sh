#!/bin/bash
set -euo pipefail

wd=${1:-/mnt/ssd512/ctr_cfg}

cd $wd

for d in */ ; do
	# Remove trailing slash from directory
	d=${d%/}
	cd $d
	if [ -f ".no_upgrade" ]; then
		echo "Skipping $d"
		cd ..
		continue
	fi
	(
		echo "restarting $d"
		docker compose down
		docker compose up -d --remove-orphans
	)
	result=$?
	if [ $result -ne 0 ] ; then
		echo "Error restarting $d";
	else
		echo "$d restarted successfully";
	fi
	
	cd ..
done

# Restart sablier. It will only control containers started before it was.
docker compose -f ./cloudflaretunnel/docker-compose.yml restart sablier
