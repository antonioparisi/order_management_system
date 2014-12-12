class StatusTransition < ActiveRecord::Base
  ##
  # Relationships
  belongs_to :order

  ##
  # Validations
  validates :event, :presence => true
  validates :from, :presence => true
  validates :to, :presence => true
end
