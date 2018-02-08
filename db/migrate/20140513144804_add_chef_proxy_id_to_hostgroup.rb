class AddChefProxyIdToHostgroup < ActiveRecord::Migration[4.2]
  def change
    add_column :hostgroups, :chef_proxy_id, :integer
  end
end
