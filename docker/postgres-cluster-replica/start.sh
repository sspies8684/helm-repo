#!/usr/bin/env bash

sync
rm -rf /var/lib/postgresql/data/*
su postgres -c "/usr/lib/postgresql/10/bin/pg_basebackup -U postgres -h $PRIMARY_SERVICE -D /var/lib/postgresql/data -X s -v"

echo -e "standby_mode = 'on'\nprimary_conninfo = 'host=$PRIMARY_SERVICE'\n" \
        > /var/lib/postgresql/data/recovery.conf

chmod 700 /var/lib/postgresql/data/

su postgres -c "/usr/lib/postgresql/10/bin/postgres"
#su postgres -c '/usr/lib/postgresql/10/bin/pg_ctl -D /var/lib/postgresql/data -m fast -w start'

