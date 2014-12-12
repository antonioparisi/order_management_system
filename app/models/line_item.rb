class LineItem < ActiveRecord::Base
  ##
  # Validations
  validates_numericality_of :quantity, :greater_than => 0, :presence => true
  validate :product_id, :presence => true

  ##
  # Relationships
  belongs_to :order
  belongs_to :product
end
