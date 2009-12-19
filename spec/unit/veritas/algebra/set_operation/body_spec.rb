require File.expand_path('../../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe 'Veritas::Algebra::SetOperation#body' do
  before do
    header = [ [ :id, Integer ] ]

    @left  = Relation.new(@header, [ [ 1 ] ])
    @right = Relation.new(@header, [ [ 2 ] ])
  end

  subject { SetOperationSpecs::Object.new(@left, @right).body }

  it { method(:subject).should raise_error(NotImplementedError, 'SetOperationSpecs::Object.operation must be implemented') }
end
