class AddChefPrivateKeyToHost < ActiveRecord::Migration[4.2]
  def change
    add_column :hosts, :chef_private_key, :text
  end
end
