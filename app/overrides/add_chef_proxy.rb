Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_chef_proxy",
                     :insert_bottom => "div#primary",
                     :text => ("<%= chef_proxy_form(f) %>")
                     )

Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_chef_proxy",
                     :insert_bottom => "div#primary",
                     :text => ("<%= chef_proxy_form(f) %>")
)

# strings used above, for the purposes of extraction only, as they're not
# detected within the full override template string above
N_('Chef proxy')
N_('Use this foreman proxy as an entry point to your Chef, node will be managed via this proxy')
N_('Chef environment')
