require 'spec_helper'

describe ProductSerializer do
  let(:product) { create(:product) }
  let(:serializer) { ProductSerializer.new(product).to_json }

  subject { JSON.load(serializer)['product'] }

  it { expect(subject).to have_key('id') }
  it { expect(subject).to have_key('name') }
  it { expect(subject).to have_key('net_price') }
end
