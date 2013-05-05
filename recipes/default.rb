#
# Author:: Daniel Lienert <daniel@lienert.cc>
# Copyright:: Copyright (c) 2013, Daniel Lienert
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chef_gem "chef-rewind"
require 'chef/rewind'


include_recipe "mysql::server"
include_recipe "database"

package "postfix-gld"


service "gld" do
  supports [ :status => true, :restart => true ]
  action [ :enable, :start ]
end


mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

# ADD the database / user / tables

mysql_database node['postfixgld']['mysql']['db'] do
  connection mysql_connection_info
  action :create
end


mysql_database_user node['postfixgld']['mysql']['user'] do
  connection mysql_connection_info
  password node['postfixgld']['mysql']['password']
  database_name node['postfixgld']['mysql']['db']
  host node['postfixgld']['mysql']['host']
  privileges [:select,:update,:insert,:create]
  action :grant
end


template "usr/share/gld/tables.mysql" do
  source "tables.mysql"
  owner "root"
  group "root"
  mode 0400
end


execute "mysql-install-gld.db" do
  command "/usr/bin/mysql -u #{node['postfixgld']['mysql']['user']} -p\"#{node['postfixgld']['mysql']['password']}\" #{node['postfixgld']['mysql']['db']} < /usr/share/gld/tables.mysql "
  not_if do
    require 'mysql'
    m = Mysql.new("localhost", node['postfixgld']['mysql']['user'],
                  node['postfixgld']['mysql']['password'],
                  node['postfixgld']['mysql']['db'])
    m.list_tables.include?('greylist')
  end
end


template "/etc/gld.conf" do
  source "gld.conf.erb"
  owner "root"
  group "root"
  mode 0400
  notifies :restart, "service[gld]"
end


rewind "template[/etc/postfix/main.cf]" do
  cookbook "postfixgld"
  source "postfix/main.cf.erb"
  notifies :restart, "service[postfix]"
end

