module ForemanChef
  class EnvironmentsController < ::ForemanChef::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanChef::Concerns::EnvironmentParameters

    before_action :find_resource, :only => [:edit, :update, :destroy]

    def import
      proxy = SmartProxy.authorized(:view_smart_proxies).find(params[:proxy])
      opts = params[:proxy].blank? ? {} : { :url => proxy.url, :chef_proxy => proxy }
      opts[:env] = params[:env] unless params[:env].blank?
      @importer = ChefServerImporter.new(opts)
      @changed = @importer.changes
      if @changed.values.all?(&:empty?)
        process_success :success_redirect => foreman_chef_environments_path, :success_msg => _("Nothing to synchronize")
      end
    end

    def synchronize
      proxy = SmartProxy.authorized(:view_smart_proxies).find(params[:proxy])
      if (errors = ChefServerImporter.new(:chef_proxy => proxy).obsolete_and_new(params[:changed])).empty?
        process_success :success_redirect => foreman_chef_environments_path, :success_msg => _("Successfully updated environments")
      else
        process_error :redirect => foreman_chef_environments_path, :error_msg => _("Failed to update environments: %s") % errors.to_sentence
      end

    end

    def index
      @environments = resource_base.includes(:chef_proxy).search_for(params[:search], :order => params[:order]).paginate(:page => params[:page])
    end

    def new
      @environment = ForemanChef::Environment.new
    end

    def create
      @environment = ForemanChef::Environment.new(environment_params)
      if @environment.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @environment.update_attributes(environment_params)
        process_success
      else
        process_error
      end
    end

    def destroy
      if @environment.destroy
        process_success
      else
        process_error
      end
    end

    def auto_complete_controller_name
      'foreman_chef_environments'
    end

    def environments_for_chef_proxy
      @chef_proxy = SmartProxy.authorized(:view_smart_proxies).with_features('Chef').find_by_id(params[:chef_proxy_id])
      @environments = @chef_proxy.present? ? @chef_proxy.chef_environments : []
      @type = params[:type]
      render :layout => false
    end

    protected

    def controller_permission
      'chef_environments'
    end

    def action_permission
      case params[:action]
        when 'import', 'synchronize'
          'import'
        else
          super
      end
    end
  end
end
