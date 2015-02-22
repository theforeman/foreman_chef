module ForemanChef
  module Concerns
    module Renderer
      extend ActiveSupport::Concern

      def chef_bootstrap(host)
        snippet = host.params['chef_bootstrap_template'].present? ? host.params['chef_bootstrap_template'] : 'chef-client omnibus bootstrap'
        raise SecurityError, 'snippet contains not white-listed characters' unless snippet =~ /\A[a-zA-Z0-9 _-]+\Z/
        "snippet '#{snippet}'"
      end
    end
  end
end
