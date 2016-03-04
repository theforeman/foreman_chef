module ForemanChef
  module Concerns
    module HostgroupExtensions
      extend ActiveSupport::Concern

      def inherited_chef_proxy_id
        read_attribute(:chef_proxy_id) || nested(:chef_proxy_id)
      end

      def inherited_chef_environment_id
        read_attribute(:chef_environment_id) || nested(:chef_environment_id)
      end

      def chef_proxy
        if ancestry.present?
          SmartProxy.with_features('Chef').find_by_id(inherited_chef_proxy_id)
        else
          super
        end
      end

      def chef_environment
        if ancestry.present?
          ::ForemanChef::Environment.find_by_id(inherited_chef_environment_id)
        else
          super
        end
      end

    end
  end
end
