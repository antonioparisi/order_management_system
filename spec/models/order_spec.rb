require 'spec_helper'

describe Order do
  describe 'validations' do
    it { should validate_presence_of(:order_date) }
  end

  describe 'specs' do
    describe 'status' do
      it '`DRAFT` as initial state' do
        order = build(:order)

        expect(order.status).to eq('draft')
      end

      describe 'DRAFT' do
        it 'move from `DRAFT` to `PLACED`' do
          order = build(:order)

          expect { order.place!('place', 'placed') }.to change(StatusTransition, :count).by(1)
          expect(order.status).to eq('placed')
        end

        it 'move from `DRAFT` to `cancelled` with a reason' do
          order = build(:order)
          order.reason = 'foobar'

          expect { order.cancel!('cancel', 'cancelled') }.to change(StatusTransition, :count).by(1)
          expect(order.status).to eq('cancelled')
        end

        it 'move from `DRAFT` to `cancelled` without a reason' do
          order = build(:order)

          expect { order.cancel!('cancel', 'cancelled') }.to raise_error
          expect(order.status).to eq('draft')
          expect(order.errors.messages).to include(:reason)
        end

        it 'move from `DRAFT` to `cancelled` without a reason' do
          order = build(:order)

          expect { order.place!('place', 'placed') }.to change(StatusTransition, :count).by(1)
          expect { order.pay!('pay', 'paid') }.to change(StatusTransition, :count).by(1)
          expect(order.status).to eq('paid')
        end
      end
    end

    it 'require order_date higher or equal to today' do
      order = build(:order)
      order.order_date = Date.yesterday

      expect(order.valid?).to eq(false)
      expect(order.errors.messages).to include(:order_date)
    end
  end

  describe '#editable?' do
    let(:order) { build(:order) }

    subject { order.editable? }

    context 'in `DRAFT` is editable' do
      it { expect(subject).to eq(true) }
    end

    context 'in a different state from `DRAFT` is not editable' do
      before { order.place!('place', 'placed') }
      it { expect(subject).to eq(false) }
    end
  end

  describe '#is_valid_transition?' do
    let(:order) { build(:order) }

    context 'is valid from `DRAFT` to `PLACED`' do
      subject { order.is_valid_transition?('draft', 'placed') }
      it { expect(subject).to eq(true) }
    end

    context 'is invalid from `DRAFT` to `PAID`' do
      subject { order.is_valid_transition?('draft', 'paid') }
      it { expect(subject).to eq(false) }
    end
  end
end
