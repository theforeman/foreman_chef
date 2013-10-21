class AddParentIdToFactName < ActiveRecord::Migration
  def change
    add_column :fact_names, :parent_id, :integer
    add_foreign_key :fact_names, :parent_id, :name => 'fact_names_parent_id_fk'
  end
end
