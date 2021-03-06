#!/usr/bin/env bash

if [[ -z $1 ]]; then DOMAIN_SCOTCHBOX="scotchbox.local";  else DOMAIN_SCOTCHBOX=$1; fi
if [[ -z $2 ]]; then DOMAIN_SAMPLE="sample.local";        else DOMAIN_SAMPLE=$2; fi
if [[ -z $3 ]]; then DOMAIN_DEFAULT="sites.local";        else DOMAIN_DEFAULT=$3; fi
if [[ -z $4 ]]; then VAGRANTDIR="scotch-box-proustibat";  else VAGRANTDIR=$4; fi
if [[ -z $5 ]]; then vhostFile="vhosts.conf";             else vhostFile=$5; fi
#if [[ -z $6 ]]; then vhostAppFile="apps-vhosts.conf";     else vhostAppFile=$6; fi
#if [[ -z $7 ]]; then DOMAIN_APPS="apps.local";            else DOMAIN_APPS=$7; fi


# CREATE SAMPLE FILE
   echo "Creating sample file config for vhosts..."
   sudo rm -f /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf
   sudo cp /etc/apache2/sites-available/$DOMAIN_SCOTCHBOX.conf /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf
   sudo sed -i s,$DOMAIN_SCOTCHBOX,$DOMAIN_SAMPLE,g /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf
   sudo sed -i s,/var/www/public,/var/www/$DOMAIN_SAMPLE/public,g /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf
   sudo sed -i s,/var/www/$VAGRANTDIR/public,/var/www/$DOMAIN_SAMPLE/public,g /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf

# DEFAULT HOST (SITES)
    echo "Setting $DOMAIN_DEFAULT as default host..."
    sudo cp /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf /etc/apache2/sites-available/000-default.conf
    sudo sed -i s,$DOMAIN_SAMPLE,$DOMAIN_DEFAULT,g /etc/apache2/sites-available/000-default.conf
    sudo sed -i s,/var/www/$DOMAIN_DEFAULT/public,/var/www/projects,g /etc/apache2/sites-available/000-default.conf

# SCOTCHBOX
#    echo "Updating vhost config for $DOMAIN_SCOTCHBOX..."
#    sudo sed -i s,/var/www/public,/var/www/sites/$VAGRANTDIR/public,g /etc/apache2/sites-available/$DOMAIN_SCOTCHBOX.conf
#    sudo a2ensite $DOMAIN_SCOTCHBOX.conf

# APPS HOST
#    DOMAIN=$DOMAIN_APPS
#    PUBDIR=/var/www/apps
#    echo "Creating vhost config for $DOMAIN with $PUBDIR..."
#    sudo rm -f /etc/apache2/sites-available/$DOMAIN.conf
#    sudo cp /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf /etc/apache2/sites-available/$DOMAIN.conf
#    sudo sed -i s,/var/www/$DOMAIN_SAMPLE/public,$PUBDIR,g /etc/apache2/sites-available/$DOMAIN.conf
#    sudo sed -i s,$DOMAIN_SAMPLE,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
#    sudo a2ensite $DOMAIN.conf

# CUSTOM VHOSTS
echo "# CUSTOM VHOSTS"
while IFS='' read -r line || [[ -n "$line" ]]; do
    if echo $line | grep -F = &>/dev/null
    then
        DOMAIN=$(echo "$line" | cut -d '=' -f 1)
        PUBDIR=/var/www/$(echo "$line" | cut -d '=' -f 2-)
        echo "Creating vhost config for $DOMAIN with $PUBDIR..."
        sudo rm -f /etc/apache2/sites-available/$DOMAIN.conf
        sudo cp /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf /etc/apache2/sites-available/$DOMAIN.conf
        sudo sed -i s,/var/www/$DOMAIN_SAMPLE/public,$PUBDIR,g /etc/apache2/sites-available/$DOMAIN.conf
        sudo sed -i s,$DOMAIN_SAMPLE,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
        sudo a2ensite $DOMAIN.conf
    fi
done < ./$vhostFile

# APPS VHOSTS
#echo "# APPS VHOSTS"
#while IFS='' read -r line || [[ -n "$line" ]]; do
#    if echo $line | grep -F = &>/dev/null
#    then
#        DOMAIN=$(echo "$line" | cut -d '=' -f 1)
#        PUBDIR=/var/www/apps/$(echo "$line" | cut -d '=' -f 2-)
#        echo "Creating vhost config for $DOMAIN with $PUBDIR..."
#        sudo cp /etc/apache2/sites-available/$DOMAIN_SAMPLE.conf /etc/apache2/sites-available/$DOMAIN.conf
#        sudo sed -i s,/var/www/$DOMAIN_SAMPLE/public,$PUBDIR,g /etc/apache2/sites-available/$DOMAIN.conf
#        sudo sed -i s,$DOMAIN_SAMPLE,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
#        sudo a2ensite $DOMAIN.conf
#    fi
#done < ./$vhostAppFile

# RESTART OR RELOAD APACHE
    sudo service apache2 restart
    #sudo service apache2 reload



# CREATING VARIABLE ENVIRONMENT
#    sudo bash -c \'echo export APP_ENV="development" >> /etc/apache2/envvars\'
#    sudo service apache2 restart
