module ForemanChef
  module Concerns
    module HostsControllerRescuer
      extend ActiveSupport::Concern

      included do
        rescue_from ForemanChef::ProxyException, :with => :chef_exception
      end

      private

      def chef_exception(exception)
        flash[:error] = _(exception.message)
        redirect_to :back
      end
    end
  end
end
