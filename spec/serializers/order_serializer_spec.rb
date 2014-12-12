require 'spec_helper'

describe OrderSerializer do
  let(:order) { create(:order) }
  let(:serializer) { OrderSerializer.new(order).to_json }

  subject { JSON.load(serializer)['order'] }

  it { expect(subject).to have_key('id') }
  it { expect(subject).to have_key('status') }
  it { expect(subject).to have_key('reason') }
  it { expect(subject).to have_key('order_date') }
  it { expect(subject).to have_key('vat') }
end
