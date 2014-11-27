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

#全局定义
global_defs {
   notification_email { #通知email，根据实际情况定义
     lcplj123@163.com  #可通知多个人
     changpengli.hit@gmail.com
   }
   notification_email_from root@localhost.com #email的发件滴孩子
   smtp_server 127.0.0.1 #smtp地址
   smtp_connect_timeout 30  #超时时间
   router_id LVS_DEVEL  #节点名字标识，主要用于通知中
}

#脚本的定义
#vrrp_script chk_http{
#   script "/home/chk_http.sh" #脚本链接
#	interval 3  #脚本执行间隔
#	weight 2  #脚本执行结果导致的优先级变更
#}

#vrrp 实例
vrrp_instance VI_1 {
    state BACKUP  #配置位备份服务器  取值只能是MASTER或BACKUP  此处指定的不是最终的，最终还需要通过优先级选择
    interface eth0  #实例绑定的网卡
    virtual_router_id 51  #取值范围0-255 相同的组必须一样。其实是mac地址的最后一组数据的取值,如 00-3e-...-78-{VIRTUAL_ROUTER_ID}
    priority 100  #优先级，如果两个都是BACKUP，则通过优先级决定谁是MASTER
    advert_int 1  #检查间隔，默认1s
	nopreempt  #设置位不抢占
    authentication {  #设置认证
        auth_type PASS  #认证方式
        auth_pass 1111  #密码
    }
	#此处设置的就是虚拟ip(VIP)当state为master时就添加，为backup时删除，可设置多个ip 
    virtual_ipaddress {
        192.168.253.111/24
    }

	#脚本检查
	#keepalived可以发现keepalived进程或者机器宕机等，但不能发现nginx等应用是否挂掉，所以需要脚本检查
	#track_script{
	#    chk_http
    #}

    #设置额外的监控，里面的网卡出现问题都会切换
	#track_interface{
	#    eth0
	# 	 eth1
    #}

	#notify_master "xxx.sh"  #变成master时执行的脚本
	#notify_backup "xxx.sh"  #变成backup时执行的脚本
	#notify_fault "xxx.sh"   #
	#notify_stop "xxx.sh"    #

}

EOF

chkconfig keepalived on
echo "stopping the firewall"
service firewalld stop
service keepalived start
echo "the vip is:192.168.253.111"
