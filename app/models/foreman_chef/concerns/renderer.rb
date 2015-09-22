module ForemanChef
  module Concerns
    module Renderer
      extend ActiveSupport::Concern

      # no longer needed since Foreman 1.11
      def chef_bootstrap(host)
        snippet_name = host.params['chef_bootstrap_template'].present? ? host.params['chef_bootstrap_template'] : 'chef-client omnibus bootstrap'
        raise SecurityError, 'snippet contains not white-listed characters' unless snippet_name =~ /\A[a-zA-Z0-9 _-]+\Z/
        snippet snippet_name
      end

      def validation_bootstrap_method?
        ::Setting::ForemanChef.validate_bootstrap_method
      end
    end
  end
end
