#!/bin/sh
# Author: Alexey Lesovsky
# сбор информации о текущих подключениях к БД
# первым параметром указывается статус процесса, вторым - база (опционально)

username=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f4)

#если имя базы не получено от сервера, то имя берется из /home/zabbix/.pgpass
if [ "$#" -lt 2 ]; 
  then 
    if [ ! -f /home/zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi
    dbname=$(head -n 1 /home/zabbix/.pgpass |cut -d: -f3);
  else
    dbname="$2"
fi
PARAM="$1"

case "$PARAM" in
'idle_in_transaction' )
        #query="SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'idle in transaction';"
        query="SELECT COUNT(*) FROM pg_stat_activity WHERE lower(current_query) = '<idle> in transaction';"
;;
'idle' )
        #query="SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'idle';"
        query="SELECT COUNT(*) FROM pg_stat_activity WHERE lower(current_query) = '<idle>';"
;;
'total' )
        query="SELECT COUNT(*) FROM pg_stat_activity;"
;;
'active' )
        #query="SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'active';"
        query="SELECT COUNT(*) FROM pg_stat_activity WHERE lower(current_query) NOT IN ( '<idle> in transaction', '<idle>');"
;;
'waiting' )
        query="SELECT COUNT(*) FROM pg_stat_activity WHERE waiting <> 'f';"
;;
'total_pct' )
        query="select count(*)*100/(select current_setting('max_connections')::int) from pg_stat_activity;"
;;
* ) echo "ZBX_NOTSUPPORTED"; exit 1;;
esac

psql -qAtX -F: -c "$query" -h localhost -U "$username" "$dbname"
