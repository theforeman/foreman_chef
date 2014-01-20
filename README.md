# ForemanChef

This plugin adds a Chef fact improter to Foreman. It basically means that when you setup your chef
clients to use foreman handlers (https://github.com/theforeman/chef-handler-foreman) and install
this plugin you receive nested facts from chef-client.

This plugin expects foreman to support nested facts which is was added in 1.4.
To install this plugin you just have to add this line to your gemfile

```ruby
gem 'foreman_chef', :git => 'https://github.com/ares/foreman_chef'
```

and run bundle install. Don't forget to restart foreman after this change.

If you want to use this in production I recommend to combine this plugin with foreman-background
(https://github.com/ohadlevy/foreman-background) which runs report and facts import as a background
tasks.

##  License

This project rocks and uses MIT-LICENSE.
