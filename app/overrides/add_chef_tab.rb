Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_chef_tab",
                     :insert_before => 'li#network_tab',
                     :text => ("<%= chef_tab_menu %>")
)
Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "add_chef_tab_pane",
                     :insert_before => "div#primary",
                     :text => ("<%= chef_tab_content(f) %>")
)
