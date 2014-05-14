module Actions
  module ForemanChef
    module Host
      class Destroy < Actions::EntryAction

        def plan(host)
          action_subject(host)
          plan_self :chef_proxy_id => host.chef_proxy_id
        end

        def run
          action_logger.fatal input[:chef_proxy_id]
# ::Proxy
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

