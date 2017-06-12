#!/bin/bash
#Install OpenLiteSpeed, PHP71 and Magento1.9.3.3 on CentOS7
echoY()
{
    FLAG=$1
    shift
    echo -e "\033[38;5;148m$FLAG\033[39m$@"
}
echoY "Install OpenLiteSpeed, PHP71 and Magento1.9.3.3 on CentOS7 "
echoY "=============Start System Update============"
yum update -y

echoY "=============Start Install OpenLiteSpeed============"
rpm -ivh http://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el7.noarch.rpm
yum install openlitespeed -y
sed -i 's/8088/80/g' /usr/local/lsws/conf/httpd_config.conf

echoY "=============Start Enable Port============"
sudo firewall-cmd --zone=public --permanent --add-port=7080/tcp
sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
sudo firewall-cmd --reload

echoY "=============Start Install PHP71============"
yum install lsphp71* --skip-broken -y
ln -sf /usr/local/lsws/lsphp71/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5

echoY "=============Start Setting Index============"
sed -i 's/index.html/index.php/g' /usr/local/lsws/conf/vhosts/Example/vhconf.conf
/usr/local/lsws/bin/lswsctrl start

echoY "=============Start Installing Mariadb============"
sudo yum install mariadb mariadb-server -y
sudo systemctl start mariadb

echoY "=============Start Setting mysql============"
cat <<EOF > mysql_secure_installation.sql
UPDATE mysql.user SET Password=PASSWORD('123456') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE magento;
CREATE USER 'magento' IDENTIFIED BY 'magento';
GRANT ALL PRIVILEGES ON magento.* TO 'magento';
FLUSH PRIVILEGES;
EOF
mysql -sfu root < "mysql_secure_installation.sql"
rm -f mysql_secure_installation.sql

echoY "=============Start Downloading Magento 1.9.3.3============"
yum install git -y
cd /root/; git clone https://github.com/Code-Egg/Storage.git 
tar -zxvf /root/Storage/magento-1.9.3.3.tar.gz 
mv magento /usr/local/lsws/Example/html/ 
rm -rf /root/Storage/ 

echoY "=============Start Change Folder Permition============"
chown -R nobody /usr/local/lsws/Example/html/magento/

echoY "Finish"
eth0_IP=`ip a | grep eth0 | grep inet | awk '{print $2}' | awk -F'/' '{print $1}'`
echoY "Please finish Magento installation by entering http://$ech0_IP/magento in URL"
echoY "Database=Account=Password = magento"
echoY "OpenLiteSpeed admin panel account=admin, password=123456"
echoY "Mysql account=root, password=123456"
