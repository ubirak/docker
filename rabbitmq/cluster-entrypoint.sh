#!/bin/bash
set -eu

if [ -z "${CLUSTER_WITH+x}" ]; then
    echo "Need to set CLUSTER_WITH env."
    exit 155;
fi

MAX_DELAY=${CLUSTER_DELAY:-10}
DELAY=`shuf -i1-${MAX_DELAY} -n1`

echo "Trying to cluster with ${CLUSTER_WITH}"

/usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached # Call parent entrypoint

rabbitmqctl stop_app
echo "Will wait for ${DELAY}s to join cluster"
sleep $DELAY # Wait for master to start and avoid race condition
rabbitmqctl join_cluster rabbit@$CLUSTER_WITH

# Stop the entire RMQ server. This is done so that we
# can attach to it again, but without the -detached flag
# making it run in the forground
rabbitmqctl stop

# Wait a while for the app to really stop
sleep 2s

exec /usr/local/bin/docker-entrypoint.sh "$@" # Call parent entrypoint
