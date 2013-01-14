# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'berkshelf/vagrant'
require 'vagrant-vbguest' unless defined? VagrantVbguest::Config

Vagrant::Config.run do |config|

  config.vm.box = 'precise64'

  config.vm.network :hostonly, "192.168.77.2"
  config.vm.customize ["modifyvm", :id, "--cpus", 1, "--memory", 512]
  
  config.vm.forward_port 3000, 3000

  config.vm.share_folder("v-root", "/vagrant", ".",:nfs => true)

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'ruby'
    chef.add_recipe 'simple-mongodb'
    chef.add_recipe 'simple-redis'
  end

end