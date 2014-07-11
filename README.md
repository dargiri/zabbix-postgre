0. sudo su
1. Create '.pgpass' file in /var/run/zabbix/ and in /home/zabbix/ with content:

'localhost:5432:db:user:password'

chmod 0600 /var/run/zabbix/.pgpass
chmod 0600 /home/zabbix/.pgpass
chown zabbix: /var/run/zabbix/.pgpass
chown zabbix: /var/run/zabbix/.pgpass


2. mkdir -p /usr/libexec
3. cp -r zabbix-extensions /usr/libexec/
4. chmod +xxx /usr/libexec/zabbix-extensions/scripts/*.sh
5. cp postgresql.conf /etc/zabbix/
6. Include=/etc/zabbix/postgresql.conf 
7. /etc/init.d/zabbix-agent restart
