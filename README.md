# ForemanChef

This plugin adds a Chef support to Foreman. You can find all information 
[in the plugin manual](https://theforeman.org/plugins/foreman_chef/0.8)

# Installation

There are two ways to install the plugin:

## Foreman Installer (recommended)

Follow the instructions on: https://theforeman.org/plugins/foreman_chef/0.8/#2.Installation

## Manual

To install this plugin you just have to add this line to your Gemfile.

```ruby
gem 'foreman_chef'
```

and run ```bundle install```. Don't forget to restart foreman after this change. You also have
to run migrations and seed. Note that this plugin requires also plugin on smart proxy and chef-handler-foreman
on client side.

##  License

Copyright (c) 2013-2014 Marek Hulán

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
