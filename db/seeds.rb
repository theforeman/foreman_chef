Feature.where(:name => 'Chef').first_or_create

# Configuration template snippets
defaults = {:vendor => "ForemanChef", :default => true, :locked => true}

templates = [
  {:name => "chef-client bootstrap", :source => "snippets/_chef_client_bootstrap.erb", :snippet => true},
  {:name => "chef-client omnibus bootstrap", :source => "snippets/_chef_client_omnibus_bootstrap.erb", :snippet => true},
  {:name => "chef-client gem bootstrap", :source => "snippets/_chef_client_gem_bootstrap.erb", :snippet => true},
]

templates.each do |template|
  template[:template] = File.read(File.join(ForemanChef::Engine.root, "app/views/foreman/unattended", template.delete(:source)))
  ProvisioningTemplate.where(:name => template[:name]).first_or_create.update_attributes(defaults.merge(template))
end

if ForemanChef.with_remote_execution?
  User.as_anonymous_admin do
    JobTemplate.without_auditing do
      Dir[File.join("#{ForemanChef::Engine.root}/app/views/job_templates/**/*.erb")].each do |template|
        sync = !Rails.env.test? && Setting[:remote_execution_sync_templates]
        # import! was renamed to import_raw! around 1.3.1
        if JobTemplate.respond_to?('import_raw!')
          JobTemplate.import_raw!(File.read(template), :default => true, :lock => true, :update => sync)
        else
          JobTemplate.import!(File.read(template), :default => true, :lock => true, :update => sync)
        end
      end
    end
  end
end

# Global parameters used in configuration snippets
parameters = [
  { :name => 'chef_handler_foreman_url', :value => SmartProxy.with_features('Chef').first.try(:url) || Setting[:foreman_url] },
  { :name => 'chef_server_url', :value => "https://#{Socket.gethostbyname(Socket.gethostname).first}" },
  { :name => 'chef_validation_private_key', :value => 'UNSPECIFIED, you must upload your validation key here' },
  { :name => 'chef_bootstrap_template', :value => 'chef-client omnibus bootstrap' },
  { :name => 'chef_server_certificate', :value => '' },
  { :name => 'chef_validator_name', :value => 'chef-validator' },
]

parameters.each do |parameter|
  existing = CommonParameter.find_by_name(parameter[:name])
  unless existing
    CommonParameter.create(:name => parameter[:name], :value => parameter[:value])
  end
end
