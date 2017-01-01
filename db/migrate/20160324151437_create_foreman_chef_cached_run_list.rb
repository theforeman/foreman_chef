class CreateForemanChefCachedRunList < ActiveRecord::Migration
  def change
    create_table :foreman_chef_cached_run_lists do |t|
      t.text :list, :null => false
      t.integer :host_id
    end
  end
end
