module ForemanChef
  module ChefProxyAssociation
    extend ActiveSupport::Concern

    included do
      belongs_to :chef_proxy, :class_name => "SmartProxy"
    end

  end
end
