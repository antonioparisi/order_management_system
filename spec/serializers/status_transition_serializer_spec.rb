require 'spec_helper'

describe StatusTransitionSerializer do
  let(:order) { create(:order) }
  let(:status_transition) { create(:status_transition, :order => order) }
  let(:serializer) { StatusTransitionSerializer.new(status_transition).to_json }

  subject { JSON.load(serializer)['status_transition'] }

  it { expect(subject).to have_key('id') }
  it { expect(subject).to have_key('event') }
  it { expect(subject).to have_key('from') }
  it { expect(subject).to have_key('to') }
  it { expect(subject).to have_key('order_id') }
end
