module ForemanChef
  #Inherit from the Rails module of the parent app (Foreman), not the plugin.
  #Thus, inhereits from ::Rails::Engine and not from Rails::Engine
  class Engine < ::Rails::Engine

    initializer "foreman_chef.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanChef::Engine.paths['db/migrate'].existent
    end

    #initializer 'foreman_chef.helper' do |app|
    #  ActionView::Base.send :include, FactValuesHelper
    #end

    #Include extenstions to models in this config.to_prepare block
    config.to_prepare do
      FactName.send :include, ForemanChef::FactNameExtensions
      FactValue.send :include, ForemanChef::FactValueExtensions
      FactValuesController.send :include, ForemanChef::FactValuesControllerExtensions
    end
  end
end
