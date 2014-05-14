module ForemanChef
  module ChefProxyForm
    def chef_proxy_form(f)
    # Don't show this if we have no Chef proxies, otherwise always include blank
    # so the user can choose not to use puppet on this host
    proxies = SmartProxy.with_taxonomy_scope_override(@location,@organization).with_features('Chef Proxy')
    return if proxies.count == 0
    select_f f, :chef_proxy_id, proxies, :id, :name,
             { :include_blank => blank_or_inherit_f(f, :chef_proxy) },
             { :label       => _("Chef proxy"),
               :help_inline => _("Use this foreman proxy as an entry point to your Chef, node will be managed via this proxy") }
    end
  end
end
