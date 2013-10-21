class AddRootIdToFactName < ActiveRecord::Migration
  def self.up
    add_column :fact_names, :root_id, :integer
    execute "UPDATE fact_names SET root_id = id"
  end

  def self.down
    remove_column :fact_names, :root_id, :integer
  end
end
