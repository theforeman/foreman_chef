class AddChefProxyIdToHostgroup < ActiveRecord::Migration
  def change
    add_column :hostgroups, :chef_proxy_id, :integer
  end
end
