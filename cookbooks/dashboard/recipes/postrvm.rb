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
