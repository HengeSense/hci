class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :sender_id
      t.integer :recipient_id
      t.boolean :complete
      t.string  :description

      t.timestamps
    end
  end
end
