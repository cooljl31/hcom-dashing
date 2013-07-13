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
