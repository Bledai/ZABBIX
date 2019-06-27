#!/bin/bash
url="http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm"
nginxConf="/etc/nginx/nginx.conf"
zabbixConf="/etc/zabbix/zabbix_agentd.conf"
packageList=('nginx' 'http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm' \
	'zabbix-server-mysql-4-0 zabbix-web-mysql' 'zabbix-server-mysql' 'tomcat tomcat-webapps tomcat-admin-webapps' 'zabbix-agent')
for pkg in ${packageList[@]}
do
	yum install -y ${pkg}
done


sed -i -e "/^\s.*listen.*\[\:\:\]\:80/ s/^/\#/" ${nginxConf}
sed -i -e "s/Server=127\.0\.0\.1/Server=192\.168\.100\.10/" ${zabbixConf}
sed -i -e "s/ServerActive=127\.0\.0\.1/ServerActive=192\.168\.100\.10/" ${zabbixConf}
sed -i -e "/Hostname=/ s/^/\#/" ${zabbixConf}
sed -i -e "/\#Hostname=/ s/$/\nHostname=Zabbix server/" ${zabbixConf}

systemctl enable nginx
systemctl start nginx
systemctl enable tomcat
systemctl start tomcat
systemctl enable zabbix-agent
systemctl start zabbix-agent


