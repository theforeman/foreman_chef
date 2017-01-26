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
      if f.object.is_a?(Host::Base) &&f.object.persisted? && f.object.chef_environment_differs?
        help = content_tag(:span, ' ', :class => 'pficon pficon-warning-triangle-o') + ' ' + _('Chef environment is set to %s on Chef server, submitting will override it') % f.object.fresh_chef_environment
        help = help.html_safe
      else
        help = nil
      end

      select_f(f, :chef_environment_id, environments, :id, :name,
               {:include_blank => blank_or_inherit_f(f, :chef_environment_id)},
               {:label => _("Chef environment"), :help_inline => help })
    end

    def chef_proxy_form_chef_proxy_select(f, proxies)
      select_f(f, :chef_proxy_id, proxies, :id, :name,
               { :include_blank => blank_or_inherit_f(f, :chef_proxy) },
               { :label => _("Chef proxy"),
                 :help_inline => _("Use this foreman proxy as an entry point to your Chef, node will be managed via this proxy"),
                 :data => { :url => environments_for_chef_proxy_foreman_chef_environments_path } })
    end

    def chef_tab_menu(host)
      if SmartProxy.with_features("Chef").count > 0
        warning = ''
        if chef_run_list_differs?(host)
          warning = content_tag(:span, '&nbsp;'.html_safe, :class => "pficon pficon-warning-triangle-o")
        end
        content_tag :li do
          link_to(warning + _('Chef'), '#chef', :data => { :toggle => 'tab'})
        end
      end
    end

    def chef_tab_content(f)
      render 'foreman_chef/hosts/chef_tab', :f => f
    end

    def chef_run_list_differs?(host)
      host.persisted? && host.chef_proxy_id.present? && host.run_list_differs?
    end
  end
end
