require 'spec_helper'

describe LineItemSerializer do
  include Rails.application.routes.url_helpers

  let(:order) { create(:order) }
  let(:product) { create(:product) }
  let(:line_item) { create(:line_item, :order => order, :product => product) }
  let(:serializer) { LineItemSerializer.new(line_item).to_json }

  subject { JSON.load(serializer)['line_item'] }

  it { expect(subject).to have_key('id') }
  it { expect(subject).to have_key('quantity') }
  it { expect(subject).to have_key('net_price') }
  it { expect(subject).to have_key('order_id') }
  it { expect(subject).to have_key('product_id') }
end
