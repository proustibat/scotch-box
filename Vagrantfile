# -*- mode: ruby -*-
# vi: set ft=ruby :


# SERVER CONFIGURATION
DOMAIN_SCOTCHBOX="scotchbox.local"
DOMAIN_SAMPLE="sample.local"
DOMAIN_DEFAULT="sites.local"
#DOMAIN_APPS="apps.local"
VAGRANTDIR="scotch-box-proustibat"
vhostFile="vhosts.conf"
#vhostAppFile="apps-vhosts.conf"

dirSynced="/workspace"
# dirSyncedApp="/space/www/apps"
dbFbrgSmnSrc="/workspace/faubourgsimone/site/bdd/fs-web-local.sql"
dbFbrgSmnFile="fs-web-local.sql"
dbName="fs-web-local"

# DATABASE CONFIGURATION
mysql_root_password   = "root"   # We'll assume user "root"
#mysql_version         = "5.5"    # Options: 5.5 | 5.6
#mysql_enable_remote   = "true"  # remote access enabled when true

Vagrant.configure("2") do |config|

    config.vm.box = "scotch/box"
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.hostname = "scotchbox"
    #config.vm.synced_folder dirSynced, "/var/www/sites", id: "sites", :nfs => { :mount_options => ["dmode=777","fmode=666"] }
    #config.vm.synced_folder dirSyncedApp, "/var/www/apps", id: "apps", :nfs => { :mount_options => ["dmode=777","fmode=666"] }


    # Use NFS for the shared folder
    config.vm.synced_folder dirSynced, "/var/www",
       id: "sites",
       :nfs => true,
       :mount_options => ['nolock,vers=3,udp,noatime']

    # Use NFS for the shared folder
    # config.vm.synced_folder dirSyncedApp, "/var/www/apps",
    #    id: "apps",
    #    :nfs => true,
    #    :mount_options => ['nolock,vers=3,udp,noatime']

    config.vm.provision "file",
        source: vhostFile,
        destination: vhostFile,
        preserve_order: true

    #config.vm.provision "file",
    #    source: vhostAppFile,
    #    destination: vhostAppFile,
    #    preserve_order: true

    config.vm.provision "shell",
        path: "provision-vhosts.sh",
        preserve_order: true,
        args: [ DOMAIN_SCOTCHBOX, DOMAIN_SAMPLE, DOMAIN_DEFAULT, VAGRANTDIR, vhostFile ]

    config.vm.provision "file",
        source: dbFbrgSmnSrc,
        destination: dbFbrgSmnFile,
        preserve_order: true

    config.vm.provision "shell",
        path: "provision-mysql.sh",
        preserve_order: true,
        args: [ mysql_root_password, dbFbrgSmnFile, dbName ]

end
