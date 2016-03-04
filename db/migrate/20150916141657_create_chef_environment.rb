class CreateChefEnvironment < ActiveRecord::Migration
  def up
    create_table :foreman_chef_environments do |t|
      t.string :name, :default => '', :null => false
      t.text :description, :default => ''
      t.integer :chef_proxy_id, :null => false
      t.timestamps
    end

    add_column :hosts, :chef_environment_id, :integer
    add_column :hostgroups, :chef_environment_id, :integer
  end

  def down
    remove_column :hostgroups, :chef_environment_id
    remove_column :hosts, :chef_environment_id

    drop_table :foreman_chef_environments
  end
end
