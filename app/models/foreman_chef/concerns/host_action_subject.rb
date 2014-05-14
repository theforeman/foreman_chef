module ForemanChef
  module Concerns
    module HostActionSubject
      extend ActiveSupport::Concern
      include ForemanTasks::Concerns::ActionSubject
      include ForemanTasks::Concerns::ActionTriggering

      def destroy_action
        ::Actions::ForemanChef::Host::Destroy
      end

      def action_input_key
        "host"
      end

    end
  end
end
