require 'rails_helper'

RSpec.describe Invoice, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it 'has_many line items' do
      t = Invoice.reflect_on_association(:line_items)
      expect(t.macro).to eq(:has_many)
    end
  end

  describe '#recalculate_total!' do
    it 'recalculates total after change in line items' do
      invoice = create(:invoice)

      # expected to be initial price
      expect(invoice.total).to eq(100)

      # add new line item to invoice
      line_item = create(:line_item, invoice: invoice)
      invoice.recalculate_total!
      
      # expect to consider new line item price in total
      expect(invoice.total.to_i).to eq(200)
    end
  end
end
