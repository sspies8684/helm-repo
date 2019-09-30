#!/bin/bash

# This is awful, though documented here: http://www.pgpool.net/docs/latest/en/html/pcp-commands.html
# It doesn't work.
source /root/.pcppass

get_node_status() {
    STATUS=`/usr/sbin/pcp_node_info 10 $PGPOOL_HOST $PGPOOL_PORT $POSTGRES_USER $POSTGRES_PASSWORD $1 | awk '{print $3}'`
    echo $STATUS
}

attach_node() {
    RET_VAL=`/usr/sbin/pcp_attach_node 10 $PGPOOL_HOST $PGPOOL_PORT $POSTGRES_USER $POSTGRES_PASSWORD $1`
    echo $RET_VAL
}

# Param = Node ID
check_node() {
    STATUS=$(get_node_status $1)
    echo $(date +%Y.%m.%d-%H:%M:%S)" [INFO] pgpool node with id=$1 returned status: "$STATUS;
    if [[ "$STATUS" -eq 3 ]] ; then
        ATTACH_NODE=$(attach_node $1)
        echo  $(date +%Y.%m.%d-%H:%M:%S)" [INFO] attaching-node to pgpool returned: "$ATTACH_NODE
    fi
}

check_node 0
check_node 1

exit 0
