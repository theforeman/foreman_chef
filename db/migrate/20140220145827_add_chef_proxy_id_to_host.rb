class AddChefProxyIdToHost < ActiveRecord::Migration[4.2]
  def change
    add_column :hosts, :chef_proxy_id, :integer
  end
end
