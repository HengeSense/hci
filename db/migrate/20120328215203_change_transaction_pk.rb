class ChangeTransactionPk < ActiveRecord::Migration
  def up
    add_column :transactions, :sender_id, :integer
    add_column :transactions, :recipient_id, :integer
  end

  def down
    add_column :transactions, :sender_id
    add_column :transactions, :recipient_id
  end
end
