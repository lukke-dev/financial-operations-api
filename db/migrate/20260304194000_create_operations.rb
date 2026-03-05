class CreateOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :operations do |t|
      t.string :external_id, null: false
      t.decimal :amount, null: false
      t.integer :currency, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :operations, :external_id, unique: true
  end
end