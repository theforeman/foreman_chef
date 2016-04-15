require_dependency 'setting/foreman_chef'

module Actions
  module ForemanChef
    module Host
      class Destroy < Actions::EntryAction

        def plan(host)
          action_subject(host)
          if (::Setting::ForemanChef.auto_deletion && proxy = host.chef_proxy)
            node_exists_in_chef = proxy.show_node(host.name)
            if node_exists_in_chef
              plan_self :chef_proxy_id => host.chef_proxy_id
            end

            plan_action Actions::ForemanChef::Client::Destroy, host.name, proxy
          end
        rescue => e
          ::Foreman::Logging.exception('Unable to communicate with Chef proxy', e, :logger => 'foreman_chef')
          raise ::ForemanChef::ProxyException.new(N_('Unable to communicate with Chef proxy, %s' % e.message))
        end

        def run
          proxy = ::SmartProxy.find_by_id(input[:chef_proxy_id])
          action_logger.debug "Deleting #{input[:host][:name]} on proxy #{proxy.name} at #{proxy.url}"
          self.output = proxy.delete_node(input[:host][:name])
        end

        def humanized_name
          _("Delete host")
        end

        def humanized_input
          input[:host] && input[:host][:name]
        end

        def cli_example
          return unless input[:host]
          <<-EXAMPLE
hammer host delete --id '#{task_input[:host][:id]}'
          EXAMPLE
        end

      end
    end
  end
end

