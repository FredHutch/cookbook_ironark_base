#
# Cookbook:: ironark_base
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

extras = %w(gpg-agent git)
package extras

user node['ironark']['user']['name'] do
  comment node['ironark']['user']['gecos']
  home node['ironark']['user']['home']
  manage_home true
  shell node['ironark']['user']['shell']
  password node['ironark']['user']['passwd']
end

sudo node['ironark']['user']['name'] do
  user node['ironark']['user']['name']
  nopasswd true
end

# Set up SSH config with deploy key for repositories
directory 'ironark user ssh directory' do
  path "#{node['ironark']['user']['home']}/.ssh"
  mode '0700'
  owner node['ironark']['user']['name']
end

file "#{node['ironark']['user']['home']}/.ssh/deploy" do
  content data_bag_item('keys', 'deploy_key')['private']
  owner node['ironark']['user']['name']
  mode '0600'
end

file "#{node['ironark']['user']['home']}/.ssh/deploy.pub" do
  content data_bag_item('keys', 'deploy_key')['public']
  owner node['ironark']['user']['name']
  mode '0600'
end

# This file configures ssh to use the deploy key for github
cookbook_file "#{node['ironark']['user']['home']}/.ssh/config" do
  source 'user_ssh_config'
  owner node['ironark']['user']['name']
  mode '0600'
end

node['scicomp_essentials']['repositories'].each do |r|
  apt_repository r['name'] do
    uri          r['uri']
    distribution r['distribution']
    key          r['key']
    components   r['components']
    deb_src      r['deb_src']
    arch         r['arch']
  end
end

extras = %w(beegfs-client beegfs-helperd beegfs-utils linux-source nfs-common)
package extras

include_recipe 'chef-client::config'
