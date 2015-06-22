module Actions
  module ForemanChef
    module Client
      class Destroy < Actions::EntryAction

        def plan(fqdn, proxy)
          if ::Setting::ForemanChef.auto_deletion
            client_exists_in_chef = proxy.show_client(fqdn)
            if client_exists_in_chef
              plan_self :chef_proxy_id => proxy.id, :fqdn => fqdn
            end
          end
        rescue => e
          Rails.logger.debug "Unable to communicate with Chef proxy, #{e.message}"
          Rails.logger.debug e.backtrace.join("\n")
          raise ::ForemanChef::ProxyException.new(N_('Unable to communicate with Chef proxy, %s' % e.message))
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

