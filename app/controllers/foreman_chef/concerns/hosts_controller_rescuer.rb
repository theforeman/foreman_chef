module ForemanChef
  module Concerns
    module HostsControllerRescuer
      extend ActiveSupport::Concern

      included do
        rescue_from ForemanChef::ProxyException, :with => :chef_exception
        # this route is only allowed to puppet proxies so we need to allow it for chef proxies too
        alias_method_chain :require_smart_proxy_or_login, :chef
      end

      private

      def require_smart_proxy_or_login_with_chef(features = nil)
        if params[:action] == 'externalNodes' && features.kind_of?(Array) && features.include?('Puppet')
          require_smart_proxy_or_login_without_chef(features + [ 'Chef' ])
        else
          require_smart_proxy_or_login_without_chef(features)
        end
      end

      def chef_exception(exception)
        flash[:error] = _(exception.message)
        redirect_to :back
      end
    end
  end
end
