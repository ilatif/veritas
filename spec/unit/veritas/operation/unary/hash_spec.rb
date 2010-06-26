require 'spec_helper'

describe 'Veritas::Operation::Unary#hash' do
  subject { unary_operation.hash }

  let(:klass)           { Class.new { include Operation::Unary } }
  let(:operand)         { mock('Operand')                        }
  let(:unary_operation) { klass.new(operand)                     }

  it { should be_kind_of(Integer) }

  it { should == operand.hash }

  it_should_behave_like 'an idempotent method'
end
