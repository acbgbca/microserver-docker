#!/bin/bash

set -xe

rc-service sshd start
rc-service dockerd start

./code serve-web --help

./code tunnel --help

if [ "${COMMAND,,}" = "web" ]; then
    su $USER -c "./code serve-web --port $WEB_PORT --host $WEB_HOST --server-data-dir $SERVER_DATA_DIR --cli-data-dir $CLI_DATA_DIR --accept-server-license-terms --without-connection-token"
elif [ "${COMMAND,,}" = "tunnel" ]; then
    su $USER -c "./code tunnel --accept-server-license-terms --server-data-dir $SERVER_DATA_DIR --cli-data-dir $CLI_DATA_DIR --name acbgbca"
else
    echo "\$COMMAND '$COMMAND' isn't valid. Must be either 'WEB' or 'TUNNEL'."
fi
