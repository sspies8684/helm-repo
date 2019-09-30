#! /bin/bash
set -e -o pipefail

DATE_FORMAT="+%Y-%m-%d"

mkdir -p "/tmp/backups/"
ARCHIVE="/tmp/backups/pgdump-$(date $DATE_FORMAT).sql.gz"

echo "Dumping all DBs to $ARCHIVE"
export PGPASSWORD=$POSTGRES_PASSWORD
pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER $POSTGRES_DB | gzip -9 > $ARCHIVE

aws s3 cp $ARCHIVE s3://datapath-backups/speyside/$ENVIRONMENT/postgres/
echo "Backup complete"