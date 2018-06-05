module ForemanChef
  module Concerns
    module HostsControllerRescuer
      def self.prepended(base)
        base.rescue_from ForemanChef::ProxyException, :with => :chef_exception
      end

      private

      def require_smart_proxy_or_login(features = nil)
        if params[:action] == 'externalNodes' && features.kind_of?(Array) && features.include?('Puppet')
          super(features + [ 'Chef' ])
        else
          super(features)
        end
      end

      def chef_exception(exception)
        flash[:error] = _(exception.message)
        redirect_to :back
      end
    end
  end
end
