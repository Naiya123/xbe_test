class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.decimal :price
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
