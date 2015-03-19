require 'deface'

module ForemanChef
  #Inherit from the Rails module of the parent app (Foreman), not the plugin.
  #Thus, inhereits from ::Rails::Engine and not from Rails::Engine
  class Engine < ::Rails::Engine

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanChef::Engine.load_seed
      end
    end

    initializer 'foreman_chef.load_default_settings', :before => :load_config_initializers do
      require_dependency File.expand_path('../../../app/models/setting/foreman_chef.rb', __FILE__) if (Setting.table_exists? rescue(false))
    end

    initializer "foreman_chef.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanChef::Engine.paths['db/migrate'].existent
    end

    initializer "foreman_chef.register_paths" do |app|
      ForemanTasks.dynflow.config.eager_load_paths.concat(%W[#{ForemanChef::Engine.root}/app/lib/actions])
    end

    initializer 'foreman_chef.register_plugin', :after => :finisher_hook do |app|
      Foreman::Plugin.register :foreman_chef do
        requires_foreman '>= 1.4'
        allowed_template_helpers :chef_bootstrap
      end
    end

    initializer 'foreman_chef.chef_proxy_form' do |app|
      ActionView::Base.send :include, ChefProxyForm
      ActionView::Base.send :include, ForemanChef::Concerns::Renderer
    end

    initializer 'foreman_chef.dynflow_world', :before => 'foreman_tasks.initialize_dynflow' do |app|
       ForemanTasks.dynflow.require!
    end

    #Include extensions to models in this config.to_prepare block
    config.to_prepare do
      ::Host::Managed.send :include, ForemanChef::HostExtensions
      ::Hostgroup.send :include, ForemanChef::HostgroupExtensions
      ::Host::Managed.send :include, ChefProxyAssociation
      ::Hostgroup.send :include, ChefProxyAssociation
      ::SmartProxy.send :include, SmartProxyExtensions
      ::FactImporter.register_fact_importer(:foreman_chef, ForemanChef::FactImporter)
      ::FactParser.register_fact_importer(:foreman_chef, ForemanChef::FactParser)
      ::Host::Base.send :include, ForemanChef::Concerns::HostActionSubject
    end

    config.after_initialize do
      ::Foreman::Renderer.send :include, ForemanChef::Concerns::Renderer
    end
  end
end
