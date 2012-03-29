class ChangeTransactionAmount < ActiveRecord::Migration
  def up
    remove_column :transactions, :amount
    remove_column :users, :balance
    add_column :transactions, :amount, :integer
    add_column :users, :balance, :integer
  end

  def down
    remove_column :transactions, :amount
    remove_column :users, :balance
    add_column :transactions, :amount, :decimal, :precision => 8, :scale => 2
    add_column :users, :balance, :decimal, :precision => 8, :scale => 2
  end
end
