module Actions
  module ForemanChef
    module Client
      class Create < Actions::EntryAction

        def plan(name, proxy)
          return if proxy.nil?

          client_exists_in_chef = proxy.show_client(name)
          if client_exists_in_chef
            raise ::ForemanChef::ObjectExistsException.new(N_('Client with name %s already exist on this Chef proxy' % name))
          else
            plan_self :chef_proxy_id => proxy.id, :name => name
          end
        rescue => e
          Foreman::Logging.exception("Unable to communicate with Chef proxy", e)
          raise ::ForemanChef::ProxyException.new(N_('CLIENT Unable to communicate with Chef proxy, %s' % e.message))
        end

        def run
          proxy = ::SmartProxy.unscoped.find_by_id(input[:chef_proxy_id])
          action_logger.debug "Creating client #{input[:name]} on proxy #{proxy.name} at #{proxy.url}"
          self.output = proxy.create_client(input[:name])
        end

        def humanized_name
          _("Create client")
        end

        def humanized_input
          input[:name]
        end
      end
    end
  end
end

