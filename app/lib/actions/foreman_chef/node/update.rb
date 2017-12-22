module Actions
  module ForemanChef
    module Node
      class Update < Actions::EntryAction

        def plan(host, proxy)
          name = host.name
          raise ::ForemanChef::HostDoesNotHaveChefProxy.new(N_('Host with name %s does not have chef proxy specified but asked to update the node') % name) if proxy.nil?

          node_exists_in_chef = proxy.show_node(name)
          if node_exists_in_chef
            # we can't use host.run_list.list_changed? or similar since it's after_save already
            if host.differs?
              plan_self :chef_proxy_id => proxy.id, :host_id => host.id
            else
              Rails.logger.debug "Host data do not differ from corresponding Chef server Node, skipping update"
            end
          else
            raise ::ForemanChef::ObjectDoesNotExistException.new(N_('Node with name %s does not exist on this Chef proxy' % name))
          end
        rescue => e
          ::Foreman::Logging.exception("Unable to communicate with Chef proxy", e)
          raise ::ForemanChef::ProxyException.new(N_('Unable to communicate with Chef proxy, %s' % e.message))
        end

        def run
          proxy = ::SmartProxy.unscoped.find_by_id(input[:chef_proxy_id])
          host = ::Host.unscoped.find(input[:host_id])
          action_logger.debug "Updating node #{input[:name]} on proxy #{proxy.name} at #{proxy.url}"
          proxy.update_node(host.name, host.run_list.as_chef_json.merge(:chef_environment => host.chef_environment.name))
        end

        def humanized_name
          _("Update node")
        end

        def humanized_input
          input[:name]
        end
      end
    end
  end
end

