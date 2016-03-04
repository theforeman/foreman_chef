module ForemanChef
  module Concerns
    module HostAndHostgroupExtensions
      extend ActiveSupport::Concern

      included do
        belongs_to :chef_proxy, :class_name => "SmartProxy"
        belongs_to :chef_environment, :class_name => "ForemanChef::Environment"

        attr_accessible :chef_proxy_id, :chef_environment_id
      end

      def available_chef_environments
        self.chef_proxy.present? ? self.chef_proxy.chef_environments : []
      end
    end
  end
end
