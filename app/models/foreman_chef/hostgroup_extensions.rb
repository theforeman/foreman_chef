module ForemanChef
  module HostgroupExtensions
    extend ActiveSupport::Concern

    # create or overwrite instance methods...
    module InstanceMethods
      def inherited_chef_proxy_id
        read_attribute(:chef_proxy_id) || nested(:chef_proxy_id)
      end

      def chef_proxy
        if ancestry.present?
          SmartProxy.with_features('Chef Proxy').find_by_id(inherited_chef_proxy_id)
        else
          super
        end
      end
    end

  end
end
