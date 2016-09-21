module ForemanChef
  module Concerns
    module HostExtensions
      extend ActiveSupport::Concern

      included do
        alias_method_chain :inherited_attributes, :chef_attributes
      end

      def inherited_attributes_with_chef_attributes
        inherited_attributes_without_openscap.concat(%w(chef_proxy_id chef_environment_id))
      end
    end
  end
end
