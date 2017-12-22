module Actions
  module ForemanChef
    module Host
      class Create < Actions::EntryAction

        def resource_locks
          :link
        end

        def plan(host)
          action_subject(host)

          if host.chef_proxy
            client_exists_in_chef = host.chef_proxy.show_client(host.name)

            sequence do
              if client_exists_in_chef
                plan_action Actions::ForemanChef::Client::Destroy, host.name, host.chef_proxy
              end

              unless ::Setting[:validation_bootstrap_method]
                client_creation = plan_action Actions::ForemanChef::Client::Create, host.name, host.chef_proxy
              end

              plan_self(:create_action_output => client_creation.try(:output) || {})
            end
          end
        rescue => e
          ::Foreman::Logging.exception("Unable to communicate with Chef proxy", e)
          raise ::ForemanChef::ProxyException.new(N_('Unable to communicate with Chef proxy, %s' % e.message))
        end

        def finalize
          if input[:create_action_output][:private_key].present? && !::Setting[:validation_bootstrap_method]
            host = ::Host.unscoped.find(self.input[:host][:id])
            host.chef_private_key = input[:create_action_output][:private_key]
            host.disable_dynflow_hooks { |h| h.save! }
          end
        end

        def humanized_name
          _("Create host")
        end

        def humanized_input
          input[:host][:name]
        end
      end
    end
  end
end

