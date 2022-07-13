class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.integer :status
      t.decimal :total

      t.timestamps
    end
  end
end
