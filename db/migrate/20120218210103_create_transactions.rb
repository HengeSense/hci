class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.decimal :amount, :precision => 8, :scale => 2
      t.string  :sender_email
      t.string  :recipient_email
      t.boolean :complete
      t.string  :description
      
      t.timestamps
    end
    add_index :transactions, :sender_email
    add_index :transactions, :recipient_email
  end
end
