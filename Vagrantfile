# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "hcombox"
  config.vm.forward_port 8081, 4567

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe("dashboard::prervm")
    chef.add_recipe("git")
    chef.add_recipe("yum::epel")
    chef.add_recipe("rvm::user")
#    chef.add_recipe("rvm::vagrant")
    chef.add_recipe("mongodb::10gen_repo")
    chef.add_recipe("mongodb")
    chef.add_recipe("dashboard::postrvm")

    chef.json = {
      'rvm' => {
  	    'user_installs' => [
          {
            'user' => 'hcomdashboard',
            'rubies' => [ "1.9.2" ],
            'default_ruby' => "ruby-1.9.2-p320",
            'gems' => {
              'ruby-1.9.2-p320' => [ {'name'    => 'bundler' } ]
            }
          }
        ]
      },
      'vagrant' => {
        'system_chef_solo' => '/usr/bin/chef-solo'
      }
    }
  end

end
