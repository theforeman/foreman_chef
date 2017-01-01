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

              unless ::Setting::ForemanChef.validate_bootstrap_method
                client_creation = plan_action Actions::ForemanChef::Client::Create, host.name, host.chef_proxy
              end

              plan_self(:create_action_output => client_creation.output)
            end
          end
        rescue => e
          Rails.logger.debug "Unable to communicate with Chef proxy, #{e.message}"
          Rails.logger.debug e.backtrace.join("\n")
          raise ::ForemanChef::ProxyException.new(N_('Unable to communicate with Chef proxy, %s' % e.message))
        end

        def finalize
          if input[:create_action_output][:private_key].present? && Setting.validation_bootstrap_method
            host = ::Host.find(self.input[:host][:id])
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

