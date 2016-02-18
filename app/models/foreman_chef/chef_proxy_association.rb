module ForemanChef
  module ChefProxyAssociation
    extend ActiveSupport::Concern

    included do
      belongs_to :chef_proxy, :class_name => "SmartProxy"

      attr_accessible :chef_proxy_id
    end

  end
end
