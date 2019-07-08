#!/bin/bash


rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat /vagrant/elasticsearch.repo > /etc/yum.repos.d/elasticsearch.repo
cat /vagrant/kibana.repo  > /etc/yum.repos.d/kibana.repo 
 
yum install -y elasticsearch
yum install -y kibana

echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: node-1" >> /etc/elasticsearch/elasticsearch.yml
echo 'node.name: node-1' >>  /etc/elasticsearch/elasticsearch.yml




systemctl enable elasticsearch
systemctl enable kibana
systemctl start elasticsearch
systemctl start kibana

