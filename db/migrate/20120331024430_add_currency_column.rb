class AddCurrencyColumn < ActiveRecord::Migration
  def up
    add_column :transactions, :currency, :string
    add_column :users, :currency, :string
    add_column :items, :transaction_id, :integer
  end

  def down
    remove_column :transactions, :currency
    remove_column :users, :currency
    remove_column :items, :transaction_id
  end
end
