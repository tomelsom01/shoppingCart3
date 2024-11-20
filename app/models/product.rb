class Product < ApplicationRecord
  has_many :cart_items
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # If price is stored as a string, you might want to add a getter method:
  def price
    self[:price].to_f
  end
end
