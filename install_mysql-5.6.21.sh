#!/bin/bash
basedir="/kusoft"  #mysql install dir /kusoft/mysql
datadir="/data"  #mysql data store
if [ ! -d "${basedir}/mysql" ];then
	mkdir -p ${basedir}/mysql
fi
if [ ! -d "${datadir}/mysql" ];then
	mkdir -p ${datadir}/mysql
fi
if [ ! -d "${datadir}/mysql/log" ];then
	mkdir -p ${datadir}/mysql/log
fi
mysqlpath="${basedir}/mysql"
datapath="${datadir}/mysql"
logpath="${datadir}/mysql/log"
if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.6.21-linux-glibc2.5-x86_64
  if [ ! -f mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz ];then
	 wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.6.21-linux-glibc2.5-x86_64.tar.gz
  mv mysql-5.6.21-linux-glibc2.5-x86_64/* ${mysqlpath}
else
  rm -rf mysql-5.6.21-linux-glibc2.5-i686
  if [ ! -f mysql-5.6.21-linux-glibc2.5-i686.tar.gz ];then
  wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.6.21-linux-glibc2.5-i686.tar.gz
  fi
  tar -xzvf mysql-5.6.21-linux-glibc2.5-i686.tar.gz
  mv mysql-5.6.21-linux-glibc2.5-i686/* ${mysqlpath}

fi
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
${mysqlpath}/scripts/mysql_install_db --datadir=${datapath} --basedir=${mysqlpath} --user=mysql
chown -R mysql:mysql ${mysqlpath}
chown -R mysql:mysql ${datapath}
\cp -f ${mysqlpath}/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir='"${mysqlpath}"'#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir='"${datapath}"'#' /etc/init.d/mysqld
cat > /etc/my.cnf <<END
[client]
port            = 3306
socket          = /tmp/mysql.sock
[mysqld]
port            = 3306
socket          = /tmp/mysql.sock
skip-external-locking
log-error=${logpath}/error.log
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M

log-bin=mysql-bin
binlog_format=mixed
server-id       = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
END

chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
