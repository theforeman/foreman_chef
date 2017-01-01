module Actions
  module ForemanChef
    module Host
      class Update < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(host)
          action_subject(host)

          if host.chef_proxy
            node_exists_in_chef = host.chef_proxy.show_node(host.name)

            if node_exists_in_chef && host.override_chef_attributes
              plan_action Actions::ForemanChef::Node::Update, host, host.chef_proxy
            end
          end
        rescue => e
          Rails.logger.debug "Unable to communicate with Chef proxy, #{e.message}"
          Rails.logger.debug e.backtrace.join("\n")
          raise ::ForemanChef::ProxyException.new(N_('Unable to communicate with Chef proxy, %s' % e.message))
          # TODO these errors causing form not to display anything and double traces, we need reraise
        end

        def humanized_name
          _("Update host")
        end

        def humanized_input
          input[:host][:name]
        end
      end
    end
  end
end

