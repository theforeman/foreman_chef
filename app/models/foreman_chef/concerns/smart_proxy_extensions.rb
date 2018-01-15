module ForemanChef
  module Concerns
    module SmartProxyExtensions
      extend ActiveSupport::Concern

      def self.prepended(base)
        base.has_many :chef_environments, :class_name => "::ForemanChef::Environment", :foreign_key => 'chef_proxy_id'
      end

      def taxonomy_foreign_conditions_with_chef
        conditions = super
        if has_feature?('Chef')
          conditions[:chef_proxy_id] = id
        end
        conditions
      end

      # create or overwrite instance methods...
      def show_node(fqdn)
        reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).show_node(fqdn)
        JSON.parse(reply)
      rescue RestClient::ResourceNotFound
        Foreman::Logging.logger('foreman_chef').debug "Node '#{fqdn}' not found"
        return false
      end

      def update_node(fqdn, attributes)
        begin
          reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).update_node(fqdn, attributes)
          JSON.parse(reply)
        end
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

      def create_client(fqdn)
        begin
          reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).create_client(fqdn)
          JSON.parse(reply)
        end
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
