module ForemanChef
  module Concerns
    module HostBuild
      extend ActiveSupport::Concern
      included do
        include ForemanTasks::Concerns::ActionSubject
        include ForemanTasks::Concerns::ActionTriggering

        after_build do |host|
          ::ForemanTasks.sync_task ::Actions::ForemanChef::Client::Destroy, host.name, host.chef_proxy
          # private key is no longer valid
          host.chef_private_key = nil

          if Setting.validation_bootstrap_method
            new_client = ::ForemanTasks.sync_task ::Actions::ForemanChef::Client::Create, host.name, host.chef_proxy
            host.chef_private_key = new_client.output[:private_key]
          end

          host.disable_dynflow_hooks { |h| h.save! }
        end
      end

    end
  end
end
