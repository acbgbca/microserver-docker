#!/bin/sh
set -e

wd=${1:-/ctr_cfg}

cd $wd

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

for d in */ ; do
	echo "Upgrading $d"

	cd $d

	if [ -f ".no_upgrade" ]; then

		echo "Skipping $d"
		
	else
		docker-compose down

		# Download updated containers
		# docker-compose pull --ignore-pull-failures

		# Rebuild any docker container defined in the docker-compose file
		# docker-compose build --no-cache

		# Upgrade container if required
		docker-compose up -d --remove-orphans
		
	fi
	cd ..
done

# Remove old images
docker image prune -f

