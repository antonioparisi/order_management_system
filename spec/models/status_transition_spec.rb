require 'spec_helper'

describe StatusTransition do
  describe 'validations' do
    it { should validate_presence_of(:event) }
    it { should validate_presence_of(:from) }
    it { should validate_presence_of(:to) }
  end

  describe 'associations' do
    it { should belong_to :order }
  end
end
