#!/bin/bash
set -e

cd /etc/pgpool2

cat > pgpool.conf <<EOF
listen_addresses = '*'
port = 5432
pcp_listen_addresses = '*'
pcp_port = 9898
pcp_socket_dir = '/var/run/postgresql'
listen_backlog_multiplier = 2

backend_hostname0 = '$MASTER_HOSTNAME'
backend_port0 = 5432
backend_weight0 = $MASTER_WEIGHT
backend_flag0 = 'ALLOW_TO_FAILOVER'

backend_hostname1 = '$SLAVE_HOSTNAME'
backend_port1 = 5432
backend_weight1 = $SLAVE_WEIGHT
backend_flag1 = 'ALLOW_TO_FAILOVER'


num_init_children = 32
max_pool = 4
child_life_time = 300
child_max_connections = 0
connection_life_time = 0
client_idle_limit = 0
log_destination = 'stdout'
log_line_prefix = '%t: pid %p: '   # printf-style string to output at beginning of each log line.
log_connections = off
log_hostname = off
log_statement = off
log_per_node_statement = off
log_standby_delay = 'if_over_threshold'
syslog_facility = 'LOCAL0'
syslog_ident = 'pgpool'
debug_level = 0
pid_file_name = '/var/run/postgresql/pgpool.pid'
logdir = '/var/log/postgresql'
connection_cache = on
reset_query_list = 'ABORT; DISCARD ALL'
enable_pool_hba = on

load_balance_mode = on
ignore_leading_white_space = on
white_function_list = ''
black_function_list = 'currval,lastval,nextval,setval'
allow_sql_comments = off

master_slave_mode = on
master_slave_sub_mode = 'stream'
sr_check_period = 0
sr_check_user = '$POSTGRES_USER'
sr_check_password = '$POSTGRES_PASSWORD'
delay_threshold = 10000000
follow_master_command = ''

health_check_period = 5
health_check_timeout = 20
health_check_user = '$POSTGRES_USER'
health_check_password = '$POSTGRES_PASSWORD'
health_check_max_retries = 0
health_check_retry_delay = 1
connect_timeout = 10000

fail_over_on_backend_error = on
search_primary_node_timeout = 10

recovery_user = '$POSTGRES_USER'
recovery_password = '$POSTGRES_PASSWORD'
recovery_timeout = 90
client_idle_limit_in_recovery = 0

use_watchdog = off
memory_cache_enabled = off
EOF

md5="host all all 0.0.0.0/0 md5"
echo $md5 >> pg_hba.conf
echo $md5 >> pool_hba.conf

pg_md5 -m -u $POSTGRES_USER $POSTGRES_PASSWORD

echo "$POSTGRES_USER:$(pg_md5 $POSTGRES_PASSWORD)" > pcp.conf

cat > /root/.pcppass <<EOF
PGPOOL_HOST=localhost
PGPOOL_PORT=9898
POSTGRES_USER="$POSTGRES_USER"
POSTGRES_PASSWORD="$POSTGRES_PASSWORD"
PGPOOL_HOSTNAME="$PGPOOL_HOSTNAME"
EOF

cron &

exec "$@"
