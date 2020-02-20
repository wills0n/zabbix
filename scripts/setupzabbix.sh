#!/bin/bash

sudo wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+bionic_all.deb
sudo dpkg -i zabbix-release_4.0-2+bionic_all.deb
sudo apt update

sudo apt install zabbix-server-mysql -y
sudo apt install zabbix-frontend-php -y
sudo apt install zabbix-agent -y
sudo apt install git curl php-curl mc htop -y


sudo mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by '31832312';"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
sudo mysql -uroot -e "quit"

sudo zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | sudo mysql -uzabbix zabbix -p31832312

sudo git clone https://github.com/vasyakrg/zabbix-alert-scripts.git /usr/lib/zabbix/alertscripts
sudo chown -R zabbix:root /usr/lib/zabbix/alertscripts

sudo cp ~/zabconf/zabbix_server.conf /etc/zabbix
sudo cp ~/zabconf/apache.conf /etc/zabbix

sudo service apache2 restart
sudo service zabbix-server start
sudo update-rc.d zabbix-server enable
