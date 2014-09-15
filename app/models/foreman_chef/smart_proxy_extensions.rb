module ForemanChef
  module SmartProxyExtensions
    extend ActiveSupport::Concern

    # create or overwrite instance methods...
    def show_node(fqdn)
      reply = ProxyAPI::ForemanChef::ChefProxy.new(:url => url).show_node(fqdn)
      JSON.parse(reply)
    rescue RestClient::ResourceNotFound
      logger.debug "Node '#{fqdn}' not found"
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
      logger.debug "Client '#{fqdn}' not found"
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
