require 'spec_helper'

describe LineItem do
  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to :order }
    it { should belong_to :product }
  end
end
