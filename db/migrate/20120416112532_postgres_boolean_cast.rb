class PostgresBooleanCast < ActiveRecord::Migration
  def up
  	change_column :users, :is_merchant, :boolean, :default=>false
  end

  def down
  	change_column :users, :is_merchant, :boolean, :default=>0
  end
end
