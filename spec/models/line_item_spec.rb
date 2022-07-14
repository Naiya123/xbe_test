require 'rails_helper'

RSpec.describe LineItem, type: :model do
  subject { described_class.new }
  it 'belongs to an invoice' do
    t = LineItem.reflect_on_association(:invoice)
    expect(t.macro).to eq(:belongs_to)
  end

  it "is valid with valid attributes" do
    subject.invoice_id = create(:invoice).id
    subject.quantity = 10
    subject.price = 20
    expect(subject).to be_valid
  end

  it "is not valid without an invoice_id" do
    subject.invoice_id = nil
    expect(subject).to_not be_valid
  end
end
