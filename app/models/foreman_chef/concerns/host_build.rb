module ForemanChef
  module Concerns
    module HostBuild
      def self.prepended(base)
        base.after_build do |host|
          ::ForemanTasks.sync_task ::Actions::ForemanChef::Client::Destroy, host.name, host.chef_proxy
          # private key is no longer valid
          host.chef_private_key = nil

          if !::Setting[:validation_bootstrap_method]
            new_client = ::ForemanTasks.sync_task ::Actions::ForemanChef::Client::Create, host.name, host.chef_proxy
            host.chef_private_key = new_client.output[:private_key]
          end

          host.disable_dynflow_hooks { |h| h.save! }
        end
      end

      def setSSHProvisionScript
        ::ForemanTasks.sync_task ::Actions::ForemanChef::Client::Destroy, self.name, self.chef_proxy
        # private key is no longer valid
        self.chef_private_key = nil

        if !::Setting[:validation_bootstrap_method]
          new_client = ::ForemanTasks.sync_task ::Actions::ForemanChef::Client::Create, self.name, self.chef_proxy
          self.chef_private_key = new_client.output[:private_key]
        end

        self.disable_dynflow_hooks { |h| super; h.save! }
      end
    end
  end
end
