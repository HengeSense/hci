class CreatePricePoints < ActiveRecord::Migration
  def change
    create_table :price_points do |t|
      t.integer  :price_cents
      t.string   :currency
      t.integer  :item_id
      t.string   :name

      t.timestamps
    end
  end
end
