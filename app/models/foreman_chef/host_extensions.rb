module ForemanChef
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :set_hostgroup_defaults, :chef_proxy
    end

    def set_hostgroup_defaults_with_chef_proxy
      set_hostgroup_defaults_without_chef_proxy
      return unless hostgroup
      assign_hostgroup_attributes(['chef_proxy_id'])
    end

  end
end
