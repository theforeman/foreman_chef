module ForemanChef
  module Concerns
    module HostExtensions
      extend ActiveSupport::Concern

      included do
        alias_method_chain :set_hostgroup_defaults, :chef_attributes
        attr_accessible :chef_private_key
      end

      def set_hostgroup_defaults_with_chef_attributes
        set_hostgroup_defaults_without_chef_attributes
        return unless hostgroup
        assign_hostgroup_attributes(['chef_proxy_id', 'chef_environment_id'])
      end
    end
  end
end
