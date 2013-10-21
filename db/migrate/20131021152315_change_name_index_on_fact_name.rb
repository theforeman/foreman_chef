class ChangeNameIndexOnFactName < ActiveRecord::Migration
  def self.up
    remove_index :fact_names, :column => :name, :unique => true
    add_index :fact_names, [:name, :type], :unique => true
  end

  def self.down
    remove_index :fact_names, [:name, :type]
    add_index :fact_names, :column => :name, :unique => true
  end
end
