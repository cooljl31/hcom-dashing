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

bash "run bundle install in app directory" do
  user "hcomdashboard"
  cwd "/home/hcomdashboard/dashboard"
#  code "bundle install --verbose"
  code "./lbundle.sh"
end

template "dashing" do
  path "/etc/init.d/hcom-dashing"
  source "hcom-dashing.erb"
  owner "root"
  group "root"
  mode "0755"
#  notifies :enable, "service[dashing]"
#  notifies :start, "service[dashing]"
end

#service "dashing" do
#  supports :restart => true, :start => true, :stop => true, :reload => true
#  action :nothing
#end
