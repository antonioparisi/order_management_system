require 'spec_helper'

describe Product do
  describe 'associations' do
    it { should have_many :line_items }
    it { should have_many :orders }
  end

  describe 'validations' do
    [:name, :net_price].each do |f|
      it { should validate_presence_of(f) }
    end

    it { should validate_uniqueness_of(:name) }

    context 'net_price' do
      describe 'present' do
        subject { build(:product) }

        it { should be_valid }
      end

      describe 'not present' do
        subject { build(:product, :net_price => nil) }

        it { should_not be_valid }
      end
    end

    context 'name' do
      describe 'present' do
        subject { build(:product) }

        it { should be_valid }
      end

      describe 'not present' do
        subject { build(:product, :name => nil) }

        it { should_not be_valid }
      end
    end

  end
end
