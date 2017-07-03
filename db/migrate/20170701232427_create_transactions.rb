class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.text :description, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.references :account, foreign_key: true
      t.datetime :date, null: false

      t.timestamps
    end
  end
end
