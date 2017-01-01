module ForemanChef
  module Concerns
    module HostExtensions
      extend ActiveSupport::Concern

      DEFAULT = ['role[default]']

      included do
        alias_method_chain :inherited_attributes, :chef_attributes

        # even with autosave, save is called only if there's some change in attributes
        has_one :cached_run_list, :autosave => true, :class_name => 'ForemanChef::CachedRunList', :foreign_key => :host_id
        attr_accessor :override_chef_attributes
      end

      def run_list
        self.cached_run_list || ForemanChef::CachedRunList.parse(DEFAULT, self.build_cached_run_list)
      end

      def run_list=(run_list)
        # returns CachedRunList instance, if there was one for host, return that one with modified attributes
        @run_list = ForemanChef::CachedRunList.parse(run_list, self.cached_run_list)
        # this ensures that host#save will save the cached run list too
        self.cached_run_list = @run_list
      end

      # although it does not save anything, it changes existing run list object attributes or builds new one
      def refresh_run_list!
        data = fresh_run_list_data
        ForemanChef::CachedRunList.parse(data, self.cached_run_list || self.build_cached_run_list) unless data.nil?
      end

      def run_list_differs?
        self.run_list.try(:list) != fresh_run_list.try(:list)
      end

      def fresh_run_list
        data = fresh_run_list_data
        @fresh_run_list ||= ForemanChef::CachedRunList.parse(data) unless data.nil?
      end

      def fresh_run_list_data
        if (data = load_node_data)
          data['run_list']
        else
          nil
        end
      end

      def chef_environment_differs?
        self.chef_environment.try(:name) != fresh_chef_environment
      end

      def fresh_chef_environment
        if (data = load_node_data)
          data['chef_environment']
        else
          nil
        end
      end

      def differs?
        run_list_differs? || chef_environment_differs?
      end

      def inherited_attributes_with_chef_attributes
        inherited_attributes_without_chef_attributes.concat(%w(chef_proxy_id chef_environment_id))
      end

      private

      def load_node_data
        self.chef_proxy && self.chef_proxy.show_node(self.name)
      end
    end
  end
end

class ::Host::Managed::Jail < Safemode::Jail
  allow :run_list
end
