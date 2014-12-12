class Order < ActiveRecord::Base
  include AASM

  ##
  # Validations
  validates :order_date, :presence => true
  validate :order_date_present_or_future

  ##
  # Relationships
  has_many :line_items
  has_many :status_transitions

  aasm :column => :status do
    state :draft, :initial => true
    state :placed
    state :paid
    state :cancelled

    event :place do
      transitions :from => :draft, :to => :placed, :after => :save_status_transition
    end

    event :pay do
      transitions :from => :placed, :to => :paid, :after => :save_status_transition
    end

    event :cancel do
      transitions :from => :draft, :to => :cancelled, :guard => :is_reasoned?, :after => :save_status_transition
      transitions :from => :placed, :to => :cancelled, :guard => :is_reasoned?, :after => :save_status_transition
    end
  end

  def editable?
    return true if draft?

    false
  end

  def is_valid_transition?(from, to)
    permitted_states = aasm.states(:permitted => true).map(&:name)

    status == from && permitted_states.include?(to.to_sym)
  end

  private

  def is_reasoned?
    return true if !reason.blank?

    errors.add(:reason, 'A reason is mandatory to cancel an order')
    false
  end

  def save_status_transition(event, to)
    transition_fields = {
      :event => event,
      :from => self.status,
      :to => to,
      :order => self
    }

    StatusTransition.create!(transition_fields)
  end


  def order_date_present_or_future
    errors.add(:order_date, 'Order date must be higher or equal to today') if !order_date.blank? && (order_date < Date.today)
  end
end
