# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'berkshelf/vagrant'
require 'vagrant-vbguest' unless defined? VagrantVbguest::Config

Vagrant::Config.run do |config|

  config.berkshelf.config_path = File.expand_path('../cookbooks/knife.rb', __FILE__)

  config.vm.box = "precise64"

  config.vm.network :hostonly, "192.168.77.2"
  config.vm.customize ["modifyvm", :id, "--cpus", 1, "--memory", 1024]
  config.vm.forward_port 3000, 3000
  config.vm.forward_port 8080, 8080

  config.vm.share_folder("v-root", "/vagrant", ".", nfs: true)
  config.vm.share_folder("v-ssh", "/tmp/.ssh", "#{Dir.home}/.ssh", nfs: true)

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = [ 'cookbooks' ]
    chef.add_recipe 'ruby'
    chef.add_recipe 'mongodb'
    chef.add_recipe 'redis'
  end

  # set auto_update to false, if do NOT want to check the correct additions 
  # version when booting this machine
  # config.vbguest.auto_update = false
  config.vbguest.auto_update = true

  # # do NOT download the iso file from a webserver
  # config.vbguest.no_remote = true

end
