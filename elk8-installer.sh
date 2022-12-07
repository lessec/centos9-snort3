#!/usr/bin/env bash
# CentOS 9 Stream with ELK Installer

## Ready to run
sudo -Sv
ORGNPATH=$(pwd)
sudo dnf install -y java-17-openjdk java-17-openjdk-devel

## Setup Elasticsearch, Logstash and Kibana
sudo update-crypto-policies --set LEGACY
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo cp "$ORGNPATH"/cfg/elasticsearch8.repo /etc/yum.repos.d/elasticsearch.repo
sudo cp "$ORGNPATH"/cfg/logstash8.repo /etc/yum.repos.d/logstash.repo
sudo cp "$ORGNPATH"/cfg/kibana8.repo /etc/yum.repos.d/kibana.repo

## Install Elasticsearch, Logstash and Kibana
sudo dnf --enablerepo=elasticsearch install -y elasticsearch logstash kiban

## Install Filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.5.2-x86_64.rpm
sudo rpm -vi filebeat-8.5.2-x86_64.rpm
