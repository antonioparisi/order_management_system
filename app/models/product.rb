class Product < ActiveRecord::Base
  ##
  # Relationships
  has_many :line_items
  has_many :orders, :through => :line_items

  ##
  # Validations
  validates :name, :uniqueness => true
  validates :name, :presence => true
  validates :net_price, :presence => true
end
