module ForemanChef
  module Concerns
    module EnvironmentParameters
      extend ActiveSupport::Concern

      class_methods do
        def environment_params_filter
          Foreman::ParameterFilter.new(::ForemanChef::Environment).tap do |filter|
            filter.permit(:name, :description, :chef_proxy_id)
          end
        end
      end

      def environment_params
        self.class.environment_params_filter.filter_params(params, parameter_filter_context, 'foreman_chef_environment')
      end
    end
  end
end
