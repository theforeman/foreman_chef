class AddChefPrivateKeyToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :chef_private_key, :text
  end
end
