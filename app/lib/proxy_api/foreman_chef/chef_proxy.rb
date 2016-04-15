module ProxyAPI
  module ForemanChef
    class ChefProxy
      PREFIX = 'chef'

      class Node < ProxyAPI::Resource
        def initialize(args)
          @url = "#{args[:url]}/#{PREFIX}/nodes"
          super args
        end
      end

      class Client < ProxyAPI::Resource
        def initialize(args)
          @url = "#{args[:url]}/#{PREFIX}/clients"
          super args
        end
      end

      class Environment < ProxyAPI::Resource
        def initialize(args)
          @url = "#{args[:url]}/#{PREFIX}/environments"
          super args
        end
      end

      def initialize(args)
        @args = args
      end

      # Shows a Chef Node entry
      # [+key+] : String containing the hostname
      # Returns : Hash representation of host on chef server
      def show_node(key)
        Node.new(@args).send(:get, key)
      end

      # Deletes a Chef Node entry
      # [+key+] : String containing the hostname
      # Returns : Boolean status
      def delete_node(key)
        Node.new(@args).send(:delete, key)
      end

      # Shows a Chef Client entry
      # [+key+] : String containing the client name
      # Returns : Hash representation of client on chef server
      def show_client(key)
        Client.new(@args).send(:get, key)
      end

      # Creates a Chef Client entry
      # [+key+] : String containing the client name
      # Returns : Hash representation of client on chef server
      def create_client(key)
        Client.new(@args).send(:post, :client => {:name => key})
      end

      # Deletes a Chef Client entry
      # [+key+] : String containing the client name
      # Returns : Boolean status
      def delete_client(key)
        Client.new(@args).send(:delete, key)
      end

      # List all Chef environments
      # Returns : Hash representation of environments on chef server
      def list_environments
        Environment.new(@args).send(:get)
      end
    end
  end
end
