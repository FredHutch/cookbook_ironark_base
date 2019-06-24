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
