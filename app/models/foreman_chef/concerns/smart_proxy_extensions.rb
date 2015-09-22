module ForemanChef
  module Concerns
    module SmartProxyExtensions
      extend ActiveSupport::Concern

      included do
        has_many :chef_environments, :class_name => "::ForemanChef::Environment", :foreign_key => 'chef_proxy_id'
      end

      # create or overwrite instance methods...
      def show_node(fqdn)
        reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).show_node(fqdn)
        JSON.parse(reply)
      rescue RestClient::ResourceNotFound
        Foreman::Logging.logger('foreman_chef').debug "Node '#{fqdn}' not found"
        return false
      end

      def delete_node(fqdn)
        begin
          reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).delete_node(fqdn)
          JSON.parse(reply)
          #rescue RestClient::
        end
      end

      def show_client(fqdn)
        reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).show_client(fqdn)
        JSON.parse(reply)
      rescue RestClient::ResourceNotFound
        Foreman::Logging.logger('foreman_chef').debug "Client '#{fqdn}' not found"
        return false
      end

      def delete_client(fqdn)
        begin
          reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).delete_client(fqdn)
          JSON.parse(reply)
          #rescue RestClient::
        end
      end
    end
  end
end
