#
# Cookbook Name:: dashboard
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

log("Hello, World") { level :info }

git "/home/hcomdashboard/dashboard" do
  user "hcomdashboard"
  repository "https://github.com/davidpallisonexp/hcom-dashing"
  reference "master"
  action :checkout
end

#bash "run bundle install in app directory" do
#  user "hcomdashboard"
#  cwd "/home/hcomdashboard/dashboard"
#  code "bundle install --verbose"
#  code "./lbundle.sh"
#end

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

#cron "setup cron for techops" do
#  user "hcomdashboard"
#  minute "0,30"
#  command "/home/hcomdashboard/dashboard/techops.sh"
#end
