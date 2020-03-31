namespace :foreman_chef do
  desc 'Clean data created by this plugin, this will permanently delete the data!'
  task :cleanup => :environment do
    puts 'Cleaning data...'

    ForemanChef::FactName # fact values

    User.as_anonymous_admin do
      puts '... deleting records from settings'
      Setting::ForemanChef.destroy_all
      puts '... removing all chef facts, this can take a long time based on the amount of fact values'
      ForemanChef::FactName.destroy_all
      puts '... deleting all cached run lists'
      ForemanChef::CachedRunList.destroy_all 
      puts '... deleting all chef environments'
      Host.update_all :chef_environment_id => nil, :chef_proxy_id => nil
      Hostgroup.update_all :chef_environment_id => nil, :chef_proxy_id => nil
      ForemanChef::Environment.destroy_all
      Permission.where(:resource_type => ['ForemanChef::Environment']).destroy_all
      puts '... deleting REX feature'
      RemoteExecutionFeature.where(:label => 'foreman_chef_run_chef_client').destroy_all
      puts 'data from all tables deleted'
    end

    puts "Cleaning DB schema changes"

    reversible_migrations = [
      20160408091653,
      20160324151437,
      20150916141657,
      20140513144804,
      20140220145827
    ]

    # invoke rake db:migrate:down VERSION=20100905201547
    reversible_migrations.each do |migration|
      ENV["VERSION"] = migration.to_s
      Rake::Task["db:migrate:down"].invoke
    end

    puts 'Clean up finished, you can now remove the plugin from your system'
  end
end

