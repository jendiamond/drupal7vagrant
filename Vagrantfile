# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/6"
  config.cache.scope = :box

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8090

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 80, host: 8090, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3306, host: 33060, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
     # Customize the amount of memory on the VM:
     vb.memory = "2048"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

   # disable selinux
   config.vm.provision "file", source: "vagrant/selinux_config", destination: "/tmp/selinux_config"
   config.vm.provision "shell", inline: <<-SHELL
      setenforce 0
      cp /tmp/selinux_config /etc/selinux/config
   SHELL

   # install apache and php
   config.vm.provision "file", source: "vagrant/drupal.conf", destination: "/tmp/drupal.conf"
   config.vm.provision "shell", inline: <<-SHELL
      yum update
      yum install -y php httpd php-mysql php-devel php-xml php-gd php-mbstring
      cp /tmp/drupal.conf /etc/httpd/conf.d/php_drupal.conf
      /sbin/chkconfig httpd on
      /etc/init.d/httpd start
   SHELL

   # install composer systemwide
   config.vm.provision "file", source: "vagrant/composer_installer", destination: "/tmp/composer_installer"
   config.vm.provision "file", source: "vagrant/composer.sh", destination: "/tmp/composer.sh"
   config.vm.provision "shell", inline: <<-SHELL
     cd /tmp;  php < composer_installer
      mv /tmp/composer.phar /usr/local/bin/composer 
      cp /tmp/composer.sh /etc/profile.d/composer.sh
   SHELL

   # install cgr and drush local to the vagrant user 
   config.vm.provision "shell", privileged: false, inline: <<-SHELL
	 composer global require consolidation/cgr
         cgr drush/drush
   SHELL

   # install community mysql 5.6
   config.vm.provision "shell", inline: <<-SHELL
     cd /tmp; wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
      rpm -Uvh /tmp/mysql-community-release-el6-5.noarch.rpm
      yum -y install mysql mysql-server
      /sbin/chkconfig mysqld on
      /etc/init.d/mysqld start
     mysql -uroot < /vagrant/vagrant/skel.sql
     mysql -uvagrant -pvagrant drupal < /vagrant/dump/mindump.sql
   SHELL

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox",
    owner: "vagrant",
    mount_options: ["dmode=755,fmode=644"]
end
