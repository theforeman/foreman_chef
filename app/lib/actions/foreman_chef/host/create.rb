module Actions
  module ForemanChef
    module Host
      class Create < Actions::EntryAction

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

        # def run
        #   # TODO create node with runlist?
        # end

        def finalize
          if input[:create_action_output][:private_key].present?
            ::Host.find(self.input[:host][:id]).update_attribute(:chef_private_key, input[:create_action_output][:private_key])
          end
        end

        def humanized_name
          _("Create node")
        end

        def humanized_input
          input[:host][:name]
        end
      end
    end
  end
end

