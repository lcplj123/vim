#!/bin/bash

yum install gcc gcc-c++ -y
yum install openssl openssl-devel popt* libnl-devel ipvsadm -y
yum install wget
wget http://www.keepalived.ogr/software/keepalived-1.2.13.tar.gz
tar zxvf keepalived-1.2.13.tar.gz
cd keepalived-1.2.13
./configure
make && make install

mkdir -p /etc/keepalived
cp /usr/local/etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak
ln -s /usr/local/etc/rc.d/init.d/keepalived /etc/init.d/
ln -s /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
ln -s /usr/local/sbin/keepalived /usr/sbin/

chkconfig keepalived on

touch /etc/keepalived/keepalived.conf

cat >> /etc/keepalived/keepalived.conf <<EOF

! Configuration File for keepalived

global_defs {
   notification_email {
     lcplj123@163.com
     changpengli.hit@gmail.com
   }
   notification_email_from root@localhost.com
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
	nopreempt
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.253.111/24
    }
}

EOF

chkconfig keepalived on
echo "stopping the firewall"
service firewalld stop
service keepalived start
echo "the vip is:192.168.253.111"
