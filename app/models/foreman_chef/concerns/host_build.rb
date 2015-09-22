module ForemanChef
  module Concerns
    module HostBuild
      extend ActiveSupport::Concern
      included do
        include ForemanTasks::Concerns::ActionSubject
        include ForemanTasks::Concerns::ActionTriggering

        after_build :plan_destroy_action
      end

    end
  end
end
