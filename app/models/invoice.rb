class Invoice < ApplicationRecord
  has_many :line_items

  def recalculate_total!
    self.total = line_items.sum(:price)
    save!
  end
end
