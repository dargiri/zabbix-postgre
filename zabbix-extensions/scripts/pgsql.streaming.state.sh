#!/bin/bash
# Author: Alexey Lesovsky
# Description: PostgreSQL streaming replication state (recovery).

username=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f4)

#если имя базы не получено от сервера, то имя берется из /home/zabbix/.pgpass
if [ -z "$*" ]; 
  then 
    if [ ! -f /home/zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi
    dbname=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f3);
  else
    dbname="postgres"
fi

psql -qAtX -h localhost -U $username -tl --dbname=$dbname -c "SELECT pg_is_in_recovery()"
