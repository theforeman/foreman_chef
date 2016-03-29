module ForemanChef
  module Concerns
    module HostExtensions
      extend ActiveSupport::Concern

      DEFAULT = ['role[default]']

      included do
        alias_method_chain :inherited_attributes, :chef_attributes

        # even with autosave, save is called only if there's some change in attributes
        has_one :cached_run_list, :autosave => true, :class_name => 'ForemanChef::CachedRunList', :foreign_key => :host_id
        attr_accessor :override_runlist
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
        fresh_run_list.try(:list) != self.run_list.try(:list)
      end

      def fresh_run_list
        @fresh_run_list ||= fresh_run_list!
      end

      def fresh_run_list_data
        if self.chef_proxy && (data = self.chef_proxy.show_node(self.name))
          data['run_list']
        else
          nil
        end
      end

      def inherited_attributes_with_chef_attributes
        inherited_attributes_without_chef_attributes.concat(%w(chef_proxy_id chef_environment_id))
      end
    end
  end
end

class ::Host::Managed::Jail < Safemode::Jail
  allow :run_list
end
