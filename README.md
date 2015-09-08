# ForemanChef

This plugin adds a Chef fact importer to Foreman. It basically means that when you setup your chef
clients to use foreman handlers (https://github.com/theforeman/chef-handler-foreman) and install
this plugin you receive nested facts from chef-client. You can find all information 
[in the plugin manual](http://www.theforeman.org/plugins/foreman_chef/0.1)

# Installation

There are two ways to install the plugin:

## Foreman Installer (recommended)

Follow the instructions on: http://www.theforeman.org/plugins/foreman_chef/0.1/#2.Installation

## Manual

This plugin expects foreman to support nested facts which is was added in 1.4.
To install this plugin you just have to add this line to your Gemfile.

```ruby
gem 'foreman_chef'
```

and run ```bundle install```. Don't forget to restart foreman after this change.

##  License

Copyright (c) 2013-2014 Marek Hulán

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
