# ForemanChef

This plugin adds a Chef fact importer to Foreman. It basically means that when you setup your chef
clients to use foreman handlers (https://github.com/theforeman/chef-handler-foreman) and install
this plugin you receive nested facts from chef-client.

This plugin expects foreman to support nested facts which is was added in 1.4.
To install this plugin you just have to add this line to your Gemfile.

```ruby
gem 'foreman_chef'
```

and run ```bundle install```. Don't forget to restart foreman after this change.

If you want to use this in production I recommend to combine this plugin with foreman-background
(https://github.com/ohadlevy/foreman-background) which runs report and facts import as a background
tasks.

##  License

Copyright (c) 2013-2014 Marek Hulán

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
