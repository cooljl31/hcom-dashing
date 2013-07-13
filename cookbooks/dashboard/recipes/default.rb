#
# Cookbook Name:: dashboard
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

log("Hello, World") { level :info }

user_account 'hcomdashboard' do
  comment   'Hcom Dashboard'
  ssh_keys  ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8MmZPbdR76f6qTZnksXbixdbe0B6+Ev3CkUP86FZAOFoD4lf/tdHLIcTJvJ/uaNw2lkMKEjELHjTBW3j2p6JSXYfydUxsBM1in+1XFzHmDmGYDdTBZz0pcXd88FUVKiXqjGURw/VUxPOdnvPhPZq3pY4WSehsX1TuH/7jmgG2IR6qf6yMhmKyywy0vx4NozJ/DiU+VB9CANYWtmoG2ypSRWSHscnKs8VR6ujsP9Ypq9P/NL1hLwGo7BD/YLSfkkE0SRRm255QrEdj1VyH4+brsPC1Cv6uQrug1em/qPXGdV6Y7LfbxUPTIznKg0kjEYySzixMx/I744CwIZhCxOh5 dallison@LONC02FT0LADF8Y.sea.corp.expecn.com']
  home      '/home/hcomdashboard'
end

git "/home/hcomdashboard/dashboard" do
  user "hcomdashboard"
  repository "https://github.com/davidpallisonexp/dashboard"
  reference "master"
  action :checkout
end

bash "run bundle install in app directory" do
  user "hcomdashboard"
  cwd "/home/hcomdashboard/dashboard"
  code "bundle install"
end

cron_package = case node['platform']
  when "redhat", "centos", "scientific", "fedora", "amazon"
    node['platform_version'].to_f >= 6.0 ? "cronie" : "vixie-cron"
  else
    "cron"
  end

package cron_package do
  action :install
end

service "crond" do
  case node['platform']
  when "redhat", "centos", "scientific", "fedora", "amazon"
    service_name "crond"
  when "debian", "ubuntu", "suse"
    service_name "cron"
  end
  action [:start, :enable]
end

cron "setup cron for techops" do
  user "hcomdashboard"
  minute "0,30"
  command "/home/hcomdashboard/dashboard/techops.sh"
end
