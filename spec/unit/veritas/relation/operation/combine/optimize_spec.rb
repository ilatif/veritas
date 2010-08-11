require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe 'Veritas::Relation::Operation::Combine#optimize' do
  subject { combine_operation.optimize }

  let(:left_body)         { [ [ 1 ], [ 2 ] ].each                                             }
  let(:right_body)        { [ [ 2, 'Dan Kubb' ] ].each                                        }
  let(:original_left)     { Relation.new([ [ :id, Integer ] ], left_body)                     }
  let(:original_right)    { Relation.new([ [ :id, Integer ], [ :name, String ] ], right_body) }
  let(:combine_operation) { CombineOperationSpecs::Object.new(left, right)                    }

  context 'left is an empty relation' do
    let(:left)  { Relation::Empty.new(original_left.header) }
    let(:right) { original_right                            }

    it 'attempts to delegate new_empty_relation' do
      expect { subject }.to raise_error(NotImplementedError, 'CombineOperationSpecs::Object#new_empty_relation')
    end
  end

  context 'right is an empty relation' do
    let(:left)  { original_left                              }
    let(:right) { Relation::Empty.new(original_right.header) }

    it 'attempts to delegate new_empty_relation' do
      expect { subject }.to raise_error(NotImplementedError, 'CombineOperationSpecs::Object#new_empty_relation')
    end
  end

  context 'left is an empty relation when optimized' do
    let(:left)  { Algebra::Restriction.new(original_left, Logic::Proposition::False.instance) }
    let(:right) { original_right                                                              }

    it 'attempts to delegate new_empty_relation' do
      expect { subject }.to raise_error(NotImplementedError, 'CombineOperationSpecs::Object#new_empty_relation')
    end
  end

  context 'right is an empty relation when optimized' do
    let(:left)  { original_left                                                                }
    let(:right) { Algebra::Restriction.new(original_right, Logic::Proposition::False.instance) }

    it 'attempts to delegate new_empty_relation' do
      expect { subject }.to raise_error(NotImplementedError, 'CombineOperationSpecs::Object#new_empty_relation')
    end
  end

  context 'left and right are not empty relations' do
    let(:left)  { original_left  }
    let(:right) { original_right }

    it { should equal(combine_operation) }

    it 'does not execute left_body#each' do
      left_body.should_not_receive(:each)
      subject
    end

    it 'does not execute right_body#each' do
      right_body.should_not_receive(:each)
      subject
    end

    it_should_behave_like 'an optimize method'
  end
end
