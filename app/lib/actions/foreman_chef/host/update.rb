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
          ::Foreman::Logging.exception("Unable to communicate with Chef proxy", e)
        end

        def humanized_name
          _("Update host")
        end

        def humanized_input
          input.try(:[], :host).try(:[], :name) || 'with unknown name'
        end
      end
    end
  end
end

