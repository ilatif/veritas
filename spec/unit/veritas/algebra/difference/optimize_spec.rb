require File.expand_path('../../../../../spec_helper', __FILE__)

describe 'Veritas::Algebra::Difference#optimize' do
  before do
    @header = [ [ :id, Integer ] ]
    @left   = Relation.new(@header, [ [ 1 ] ])
    @right  = Relation.new(@header, [ [ 2 ] ])
  end

  subject { @difference.optimize }

  describe 'left is an empty relation' do
    before do
      @left = Relation::Empty.new(@header)

      @difference = Algebra::Difference.new(@left, @right)
    end

    it { should equal(@left) }

    it 'should return an equivalent relation to the unoptimized operation' do
      should == @difference
    end
  end

  describe 'right is an empty relation' do
    before do
      @right = Relation::Empty.new(@header)

      @difference = Algebra::Difference.new(@left, @right)
    end

    it { should equal(@left) }

    it 'should return an equivalent relation to the unoptimized operation' do
      should == @difference
    end
  end

  describe 'left is an empty relation when optimized' do
    before do
      @left = Algebra::Restriction.new(@left, Algebra::Restriction::False.instance)

      @difference = Algebra::Difference.new(@left, @right)
    end

    it { should eql(Relation::Empty.new(@left.header | @right.header)) }

    it 'should return an equivalent relation to the unoptimized operation' do
      should == @difference
    end
  end

  describe 'right is an empty relation when optimized' do
    before do
      @right = Algebra::Restriction.new(@right, Algebra::Restriction::False.instance)

      @difference = Algebra::Difference.new(@left, @right)
    end

    it { should equal(@left) }

    it 'should return an equivalent relation to the unoptimized operation' do
      should == @difference
    end
  end

  describe 'left and right are not empty relations' do
    before do
      @difference = Algebra::Difference.new(@left, @right)
    end

    it { should equal(@difference) }
  end

  describe 'left and right are equivalent relations' do
    before do
      @right = @left.dup

      @difference = Algebra::Difference.new(@left, @right)
    end

    it { should eql(Relation::Empty.new(@header)) }

    it 'should return an equivalent relation to the unoptimized operation' do
      should == @difference
    end
  end
end