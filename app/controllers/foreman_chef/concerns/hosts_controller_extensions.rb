module ForemanChef
  module Concerns
    module HostsControllerExtensions
      extend ActiveSupport::Concern
      include ForemanTasks::Triggers

      module Overrides
        def destroy
          super
          ::ForemanTasks.sync_task ::Actions::ForemanChef::Host::Destroy, @host
        end

        def update
          super
          ::ForemanTasks.sync_task ::Actions::ForemanChef::Host::Update, @host
        end
      end

      included do
        prepend Overrides
      end
    end
  end
end
