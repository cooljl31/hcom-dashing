#
# Cookbook Name:: dashboard
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

log("Hello, World") { level :info }

bash "run bundle install in app directory" do
  user "hcomdashboard"
  cwd "/home/hcomdashboard/dashboard"
  code "./lbundle.sh"
#  code "> dpa.txt"
end
