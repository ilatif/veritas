require 'spec_helper'

describe 'Veritas::Relation::Operation::Limit::Methods#first' do
  subject { ordered.first(*args) }

  let(:relation) { Relation.new([ [ :id, Integer ] ], [ [ 1 ], [ 2 ], [ 3 ] ]) }
  let(:ordered)  { relation.order { |r| r[:id] }                               }

  context 'with no arguments' do
    let(:args) { [] }

    it { should be_kind_of(Relation::Operation::Limit) }

    it 'returns the expected tuples' do
      should == [ [ 1 ] ]
    end

    it 'behaves the same as Array#first' do
      should == [ ordered.to_a.first ]
    end
  end

  context 'with a limit' do
    let(:args) { [ 2 ] }

    it { should be_kind_of(Relation::Operation::Limit) }

    it 'returns the expected tuples' do
      should == [ [ 1 ], [ 2 ] ]
    end

    it 'behaves the same as Array#first' do
      should == ordered.to_a.first(2)
    end
  end
end