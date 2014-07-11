#!/bin/sh
# Author: Alexey Lesovsky
# размер отдельного индекса или таблицы без индексов - pg_relation_size

username=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f4)

#если имя базы не получено от сервера, то имя берется из /home/zabbix/.pgpass
if [ "$#" -lt 2 ]; 
  then 
    if [ ! -f /home/zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi
    dbname=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f3);
  else
    dbname="$2"
fi

if [ -z "$*" ]; then echo "ZBX_NOTSUPPORTED"; exit 1; fi

psql -qAtX -F: -c "SELECT pg_relation_size('$1');" -h localhost -U "$username" "$dbname" |cut -d' ' -f1
