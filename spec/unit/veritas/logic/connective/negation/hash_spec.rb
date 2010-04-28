require File.expand_path('../../../../../../spec_helper', __FILE__)

describe 'Veritas::Logic::Connective::Negation#hash' do
  before do
    @attribute = Attribute::Integer.new(:id)
    @operand   = @attribute.eq(1)

    @negation = Logic::Connective::Negation.new(@operand)
  end

  subject { @negation.hash }

  it { should be_kind_of(Integer) }

  it { should == @operand.hash }
end