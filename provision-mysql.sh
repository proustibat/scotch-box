#!/usr/bin/env bash

# This script is modified from this original source: https://github.com/fideloper/Vaprobash/blob/master/scripts/mysql.sh

#echo ">>> Installing MySQL Server $2"
# TODO clean this script
[[ -z "$1" ]] && { echo "!!! MySQL root password not set. Check the Vagrant file."; exit 1; }
[[ -z "$2" ]] && { echo "!!! Dump file missing"; exit 1; }
[[ -z "$3" ]] && { echo "!!! Database name missing"; exit 1; }


#mysql_package=mysql-server

#if [ $2 == "5.6" ]; then
#    # Add repo for MySQL 5.6
#	sudo add-apt-repository -y ppa:ondrej/mysql-5.6
#
#	# Update Again
#	sudo apt-get update
#
#	# Change package
#	mysql_package=mysql-server-5.6
#fi

# Install MySQL without password prompt
# Set username and password to 'root'
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"

# Install MySQL Server
# -qq implies -y --force-yes
#sudo apt-get install -qq $mysql_package

# Make MySQL connectable from outside world without SSH tunnel
#if [ $3 == "true" ]; then
    # enable remote access
    #echo "setting the mysql bind-address to allow connections from everywhere"
    #if [ $2 == "5.6" ]; then
    #    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
    #else
    #    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
    #fi

    echo "Adding grant privileges to mysql root user from everywhere"
    # thx to http://stackoverflow.com/questions/7528967/how-to-grant-mysql-privileges-in-a-bash-script for this
    MYSQL=`which mysql`

    Q1="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$1' WITH GRANT OPTION;"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"

    $MYSQL -u root -p$1 -e "$SQL"

    service mysql restart

    # DATABASE DUMP
    echo "Drop / Create database " $3
    $MYSQL -u root -p$1 -e "DROP DATABASE IF EXISTS \`$3\`"
    $MYSQL -u root -p$1 -e "CREATE DATABASE IF NOT EXISTS \`$3\`"
    echo "Dumping" $2
    $MYSQL -u root -p$1 $3 < $2
#fi


