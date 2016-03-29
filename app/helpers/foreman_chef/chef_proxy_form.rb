module ForemanChef
  module ChefProxyForm
    def chef_proxy_form(f)
      # Don't show this if we have no Chef proxies, otherwise always include blank
      # so the user can choose not to use puppet on this host
      proxies = SmartProxy.with_taxonomy_scope_override(@location,@organization).with_features('Chef')
      return if proxies.count == 0
      javascript('foreman_chef/chef_proxy_environment_refresh')

      chef_proxy_form_chef_proxy_select(f, proxies) +
        chef_proxy_form_chef_environment_select(f, f.object.available_chef_environments)
    end

    def chef_proxy_form_chef_environment_select(f, environments)
      select_f(f, :chef_environment_id, environments, :id, :name,
               {:include_blank => blank_or_inherit_f(f, :chef_environment_id)},
               {:label => _("Chef environment")})
    end

    def chef_proxy_form_chef_proxy_select(f, proxies)
      select_f(f, :chef_proxy_id, proxies, :id, :name,
               { :include_blank => blank_or_inherit_f(f, :chef_proxy) },
               { :label => _("Chef proxy"),
                 :help_inline => _("Use this foreman proxy as an entry point to your Chef, node will be managed via this proxy"),
                 :data => { :url => environments_for_chef_proxy_foreman_chef_environments_path } })
    end

    def chef_tab_menu
      if SmartProxy.with_features("Chef").count > 0
        content_tag :li do
          '<a href="#chef" data-toggle="tab">Chef</a>'.html_safe
        end
      end
    end

    def chef_tab_content(f)
      render 'foreman_chef/hosts/chef_tab', :f => f
    end
  end
end
