class AddPurchasePriceToItem < ActiveRecord::Migration
  def change
    add_column :items, :purchase_price, :integer
    add_column :items, :currency, :string
  end
end
