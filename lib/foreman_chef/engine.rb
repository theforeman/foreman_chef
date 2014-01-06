module ForemanChef
  #Inherit from the Rails module of the parent app (Foreman), not the plugin.
  #Thus, inhereits from ::Rails::Engine and not from Rails::Engine
  class Engine < ::Rails::Engine

    initializer "foreman_chef.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanChef::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_chef.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_chef do
      end if defined? Foreman::Plugin
    end

    #initializer 'foreman_chef.helper' do |app|
    #  ActionView::Base.send :include, FactValuesHelper
    #end

    #Include extenstions to models in this config.to_prepare block
    config.to_prepare do
      ::FactImporter.register_fact_importer(:foreman_chef, ForemanChef::FactImporter)
    end
  end
end
