#!/bin/bash
# Author: Alexey Lesovsky
# Description: postgres ping

username=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f4)

#echo "Executed script " >> ~/pg_ping.log

#если имя базы не получено от сервера, то имя берется из /home/zabbix/.pgpass
if [ -z "$*" ]; 
  then 
    if [ ! -f /home/zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi
    dbname=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f3);
  else
    dbname="$1"
fi

query="select 1;"
echo -e "\\\timing \n select 1" | psql -qAtX -h localhost -U "$username" "$dbname" |grep Time |cut -d' ' -f2
