require 'deface'
require 'foreman_tasks'

module ForemanChef
  #Inherit from the Rails module of the parent app (Foreman), not the plugin.
  #Thus, inhereits from ::Rails::Engine and not from Rails::Engine
  class Engine < ::Rails::Engine
    engine_name 'foreman_chef'

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanChef::Engine.load_seed
      end
    end

    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*', 'app/assets/images/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last.gsub(/\.scss\Z/, '')
        end
      end
    initializer 'foreman_chef.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_chef.configure_assets', group: :assets do
      SETTINGS[:foreman_chef] = { assets: { precompile: assets_to_precompile } }
    end

    initializer 'foreman_chef.load_default_settings', :before => :load_config_initializers do
      require_dependency File.expand_path('../../../app/models/setting/foreman_chef.rb', __FILE__) if (Setting.table_exists? rescue(false))
    end

    initializer "foreman_chef.load_app_instance_data" do |app|
      ForemanChef::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer "foreman_chef.register_paths" do |app|
      ForemanTasks.dynflow.config.eager_load_paths.concat(%W[#{ForemanChef::Engine.root}/app/lib/actions])
    end

    initializer 'foreman_chef.register_plugin', :before => :finisher_hook do |app|
      Foreman::Plugin.register :foreman_chef do
        requires_foreman '>= 1.13'
        extend_template_helpers ForemanChef::Concerns::Renderer

        permission :import_chef_environments, { :environments => [:import, :synchronize] }, :resource_type => 'ForemanChef::Environment'
        permission :view_chef_environments, { :environments => [:index, :environments_for_chef_proxy] }, :resource_type => 'ForemanChef::Environment'
        permission :edit_chef_environments, { :environments => [:edit, :update] }, :resource_type => 'ForemanChef::Environment'
        permission :destroy_chef_environments, { :environments => [:destroy] }, :resource_type => 'ForemanChef::Environment'

        divider :top_menu, :caption => N_('Chef'), :last => true, :parent => :configure_menu
        menu :top_menu, :chef_environments,
             url_hash: { controller: 'foreman_chef/environments', action: :index },
             caption: N_('Environments'),
             parent: :configure_menu,
             last: true

        parameter_filter ForemanChef::CachedRunList, :type, :name
        parameter_filter Host::Managed, :chef_private_key, :chef_proxy_id, :override_chef_attributes, :chef_environment_id, :run_list => [ parameter_filters(ForemanChef::CachedRunList) ]
        parameter_filter Hostgroup, :chef_proxy_id, :chef_environment_id
      end
    end

    initializer 'foreman_chef.chef_proxy_form' do |app|
      ActionView::Base.send :include, ChefProxyForm
    end

    initializer 'foreman_chef.dynflow_world', :before => 'foreman_tasks.initialize_dynflow' do |app|
       ForemanTasks.dynflow.require!
    end

    #Include extensions to models in this config.to_prepare block
    config.to_prepare do
      ::FactImporter.register_fact_importer(:foreman_chef, ForemanChef::FactImporter)
      ::FactParser.register_fact_parser(:foreman_chef, ForemanChef::FactParser)
      ::ConfigReportImporter.register_smart_proxy_feature('Chef')

      ::Host::Managed.send :include, ForemanChef::Concerns::HostAndHostgroupExtensions
      ::Hostgroup.send :include, ForemanChef::Concerns::HostAndHostgroupExtensions
      ::Host::Managed.send :include, ForemanChef::Concerns::HostExtensions
      ::Hostgroup.send :include, ForemanChef::Concerns::HostgroupExtensions
      ::SmartProxy.send :include, ForemanChef::Concerns::SmartProxyExtensions
      ::Host::Managed.send :include, ForemanChef::Concerns::HostActionSubject
      ::Host::Managed.send :include, ForemanChef::Concerns::HostBuild
      ::HostsController.send :include, ForemanChef::Concerns::HostsControllerRescuer
    end

    config.after_initialize do
      ::Foreman::Renderer.send :include, ForemanChef::Concerns::Renderer
    end
  end

  def self.table_name_prefix
    "foreman_chef_"
  end

  def use_relative_model_naming
    true
  end
end
