#!/bin/bash
url="http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm"
passwd=bledai
zabbixConf="/etc/zabbix/zabbix_server.conf"
# ------------ Marianadb
yum -y install mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql

systemctl start mariadb
systemctl enable mariadb.service

mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;grant all privileges on zabbix.* to zabbix@localhost identified by '${passwd}'"
rpm -import http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
sleep 20s
yum install -y ${url}
yum install -y zabbix-server-mysql-4.0.10 zabbix-web-mysql
yum install -y zabbix-server-mysql
#--------------------
zcat /usr/share/doc/zabbix-server-mysql-4.0.10/create.sql.gz | mysql -uzabbix -p zabbix -p${passwd}
#--------------------
#Configure 
sed -i -e "s/\#.*DBHost=localhost/DBHost=localhost/" ${zabbixConf}
sed -i -e "s/\#.*DBPassword=/DBPassword=bledai/" ${zabbixConf}

systemctl start zabbix-server

sed -i -e "s/\#.*php_value date\.timezone Europe\/Riga/php_value date\.timezone Europe\/Minsk/" /${zabbixConf}
systemctl start httpd	
	