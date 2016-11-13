# -*- mode: ruby -*-
# vi: set ft=ruby :

DOMAIN_SCOTCHBOX="scotchbox.local"
DOMAIN_SAMPLE="sample.local"
DOMAIN_DEFAULT="projects.local"
VAGRANTDIR="scotch-box-proustibat"
vhostFile="vhosts.conf"

Vagrant.configure("2") do |config|

    config.vm.box = "scotch/box"
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.hostname = "scotchbox"
    config.vm.synced_folder "/workspace", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

    config.vm.provision "file",
        source: vhostFile,
        destination: vhostFile,
        preserve_order: true

    config.vm.provision "shell",
        path: "provision-script.sh",
        preserve_order: true,
        args: [ DOMAIN_SCOTCHBOX, DOMAIN_SAMPLE, DOMAIN_DEFAULT, VAGRANTDIR, vhostFile ]

end
