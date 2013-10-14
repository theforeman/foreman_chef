# Ensure that module is namespaced with plugin name
module ForemanChef

  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController

    # change layout if
    # layout 'foreman_chef/layouts/new_layout'

  #  def new_action
      # automatically renders view/foreman_chef/hosts/new_action
	#  end

  end
end
