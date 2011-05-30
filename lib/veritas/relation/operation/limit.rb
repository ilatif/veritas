# encoding: utf-8

module Veritas
  class Relation
    module Operation

      # A class representing a limited relation
      class Limit < Relation
        include Unary

        # Return the limit
        #
        # @example
        #   limit = limited_relation.limit
        #
        # @return [Integer]
        #
        # @api public
        attr_reader :limit

        # The relation sort order
        #
        # @return [Operation::Order::DirectionSet]
        #
        # @api private
        attr_reader :directions

        # Instantiate a new Limit
        #
        # @example
        #   limited_relation = Limit.new(operand, limit)
        #
        # @param [Relation] operand
        #   the relation to limit
        # @param [Integer] limit
        #   the maximum number of tuples in the limited relation
        #
        # @return [Limit]
        #
        # @api public
        def self.new(operand, limit)
          assert_ordered_operand(operand)
          assert_valid_limit(limit)
          super
        end

        # Assert the operand is ordered
        #
        # @param [Relation] operand
        #
        # @return [undefined]
        #
        # @raise [OrderedRelationRequiredError]
        #   raised if the operand is unordered
        #
        # @api private
        def self.assert_ordered_operand(operand)
          if operand.header.to_ary.size != operand.directions.to_ary.size
            raise OrderedRelationRequiredError, 'can only limit an ordered operand'
          end
        end

        # Assert the limit is valid
        #
        # @param [Integer] limit
        #
        # @return [undefined]
        #
        # @raise [InvalidLimitError]
        #   raised if the limit is less than 0
        #
        # @api private
        def self.assert_valid_limit(limit)
          if limit < 0
            raise InvalidLimitError, "limit must be greater than or equal to 0, but was #{limit.inspect}"
          end
        end

        private_class_method :assert_ordered_operand, :assert_valid_limit

        # Initialize a Limit
        #
        # @param [Relation] operand
        #   the relation to limit
        # @param [Integer] limit
        #   the maximum number of tuples in the limited relation
        #
        # @return [undefined]
        #
        # @api private
        def initialize(operand, limit)
          super(operand)
          @limit      = limit.to_int
          @directions = operand.directions
        end

        # Iterate over each tuple in the set
        #
        # @example
        #   limited_relation = Limit.new(operand, limit)
        #   limited_relation.each { |tuple| ... }
        #
        # @yield [tuple]
        #
        # @yieldparam [Tuple] tuple
        #   each tuple in the set
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?
          operand.each_with_index do |tuple, index|
            break if @limit == index
            yield tuple
          end
          self
        end

        # Compare the Limit with other relation for equality
        #
        # @example
        #   limited_relation.eql?(other)  # => true or false
        #
        # @param [Relation] other
        #   the other relation to compare with
        #
        # @return [Boolean]
        #
        # @api public
        def eql?(other)
          super && limit.eql?(other.limit)
        end

        # Return the hash of the limit
        #
        # @example
        #   hash = limit.hash
        #
        # @return [Fixnum]
        #
        # @api public
        def hash
          super ^ limit.hash
        end

        module Methods

          # Return a relation with n tuples
          #
          # @example
          #   limited_relation = relation.take(5)
          #
          # @param [Integer] limit
          #   the maximum number of tuples in the limited relation
          #
          # @return [Limit]
          #
          # @api public
          def take(limit)
            Limit.new(self, limit)
          end

          # Return a relation with the first n tuples
          #
          # @example with no limit
          #   limited_relation = relation.first
          #
          # @example with a limit
          #   limited_relation = relation.first(5)
          #
          # @param [Integer] limit
          #   optional number of tuples from the beginning of the relation
          #
          # @return [Limit]
          #
          # @api public
          def first(limit = 1)
            take(limit)
          end

          # Return a relation with the last n tuples
          #
          # @example with no limit
          #   limited_relation = relation.last
          #
          # @example with a limit
          #   limited_relation = relation.last(5)
          #
          # @param [Integer] limit
          #   optional number of tuples from the end of the relation
          #
          # @return [Limit]
          #
          # @api public
          def last(limit = 1)
            reverse.take(limit).reverse
          end

        end # module Methods

        Relation.class_eval { include Methods }

        memoize :hash

      end # class Limit
    end # module Operation
  end # class Relation
end # module Veritas
