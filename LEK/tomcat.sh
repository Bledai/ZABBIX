#!/bin/bash


sudo yum install -y tomcat tomcat-webapps tomcat-admin-webapps


rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat /vagrant/logstash.repo > /etc/yum.repos.d/logstash.repo
sudo yum install -y logstash

usermod -aG tomcat logstash

cp /vargant/elasticsearch.conf > /etc/logstash/conf.d/elasticsearch.conf

systemctl enable logstash
systemctl start logstash
systemctl enable tomcat
systemctl start tomcat

