#!/bin/bash
#

set -e

# create users
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	    CREATE USER quartz WITH PASSWORD 'quartz';
	    CREATE USER litellm WITH PASSWORD 'litellm';
	    CREATE USER metabase WITH PASSWORD 'metabase';
EOSQL

# database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE test;
	GRANT ALL PRIVILEGES ON DATABASE test TO postgres;
	CREATE DATABASE quartz WITH OWNER quartz;
	CREATE DATABASE litellm WITH OWNER litellm;
	CREATE DATABASE metabaseappdb WITH OWNER metabase;
EOSQL

# quartz
psql -v ON_ERROR_STOP=1 --username quartz --dbname quartz -f /docker-entrypoint-initdb.d/quartz.sql
