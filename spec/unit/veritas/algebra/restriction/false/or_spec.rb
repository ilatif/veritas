require File.expand_path('../../../../../../spec_helper', __FILE__)

describe 'Veritas::Algebra::Restriction::False#or' do
  before do
    @other = mock('other')

    @false = Algebra::Restriction::False.instance
  end

  subject { @false.or(@other) }

  it { should equal(@other) }
end