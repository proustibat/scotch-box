#!/usr/bin/env bash

# DEFAULT HOST
    sudo sed -i s,/var/www/public,/var/www/projects,g /etc/apache2/sites-available/000-default.conf
    sudo sed -i s,/var/www/public,/var/www/projects,g /etc/apache2/sites-available/scotchbox.local.conf
    sudo service apache2 restart


# BOWBOOSH
    DOMAIN=bowboosh.local
    echo "Creating vhost config for $DOMAIN..."
    sudo cp /etc/apache2/sites-available/scotchbox.local.conf /etc/apache2/sites-available/$DOMAIN.conf

    echo "Updating vhost config for $DOMAIN..."
    sudo sed -i s,scotchbox.local,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
    sudo sed -i s,/var/www/projects,/var/www/projects/bowboosh/dist,g /etc/apache2/sites-available/$DOMAIN.conf

    echo "Enabling $DOMAIN. Will probably tell you to restart Apache..."
    sudo a2ensite $DOMAIN.conf


# GROWER
    DOMAIN=grower.local
    echo "Creating vhost config for $DOMAIN..."
    sudo cp /etc/apache2/sites-available/scotchbox.local.conf /etc/apache2/sites-available/$DOMAIN.conf

    echo "Updating vhost config for $DOMAIN..."
    sudo sed -i s,scotchbox.local,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
    sudo sed -i s,/var/www/projects,/var/www/projects/grower-js/public,g /etc/apache2/sites-available/$DOMAIN.conf

    echo "Enabling $DOMAIN. Will probably tell you to restart Apache..."
    sudo a2ensite $DOMAIN.conf


# FAUBOURGSIMONE
    DOMAIN=faubourgsimone.local
    echo "Creating vhost config for $DOMAIN..."
    sudo cp /etc/apache2/sites-available/scotchbox.local.conf /etc/apache2/sites-available/$DOMAIN.conf

    echo "Updating vhost config for $DOMAIN..."
    sudo sed -i s,scotchbox.local,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
    sudo sed -i s,/var/www/projects,/var/www/faubourgsimone/site,g /etc/apache2/sites-available/$DOMAIN.conf

    echo "Enabling $DOMAIN. Will probably tell you to restart Apache..."
    sudo a2ensite $DOMAIN.conf

# RESTART OR RELOAD APACHE
    echo "So let's restart apache..."
    #sudo service apache2 restart
    sudo service apache2 reload


# CREATING VARIABLE ENVIRONMENT
    sudo bash -c \'echo export APP_ENV="development" >> /etc/apache2/envvars\'
    sudo service apache2 restart

# IMPORT DATABASE DUMP
    #mysql -u root -proot scotchbox < /var/www/dump.sql
