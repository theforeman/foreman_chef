class AddChefProxyIdToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :chef_proxy_id, :integer
  end
end
