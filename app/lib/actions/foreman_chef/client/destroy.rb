module Actions
  module ForemanChef
    module Client
      class Destroy < Actions::EntryAction

        def plan(fqdn, proxy)
          client_exists_in_chef = proxy.show_client(fqdn)
          if client_exists_in_chef
            plan_self :chef_proxy_id => proxy.id, :fqdn => fqdn
          end
        end

        def run
          proxy = ::SmartProxy.find_by_id(input[:chef_proxy_id])
          action_logger.debug "Deleting client #{input[:fqdn]} on proxy #{proxy.name} at #{proxy.url}"
          self.output = proxy.delete_client(input[:fqdn])
        end

        def humanized_name
          _("Delete client")
        end

        def humanized_input
          input[:fqdn]
        end

      end
    end
  end
end

