module Veritas

  # Abstract class for aggregate functions
  class Aggregate
    include AbstractClass, Immutable, Visitable, Operation::Unary

    # Return the default accumulator
    #
    # @return [Object]
    #
    # @api public
    def self.default
      self::DEFAULT
    end

    # Evaluate the aggregate using the operands
    #
    # @example
    #   Aggregate.call  # => raises NotImplementedError
    #
    # @return [Object]
    #
    # @api public
    def self.call(*)
      raise NotImplementedError, "#{name}.call must be implemented"
    end

    # Return the default for this aggregate
    #
    # @return [Object]
    #
    # @api public
    def default
      self.class.default
    end

    # Evaluate the aggregate using the provided Tuple
    #
    # @example
    #   accumulator = aggregate.call(accumulator, tuple)
    #
    # @param [Object] accumulator
    #
    # @param [Tuple] tuple
    #
    # @return [Object]
    #
    # @api public
    def call(accumulator, tuple)
      self.class.call(accumulator, value(tuple))
    end

  private

    # Extract the value from the operand or tuple
    #
    # @param [Object, #call] operand
    #   the operand to extract the value from
    # @param [Tuple] tuple
    #   the tuple to pass in to the operand if it responds to #call
    #
    # @return [Object]
    #
    # @todo Aggregate will inherit from Expression, then use as Expression.value
    #
    # @api private
    def value(tuple)
      operand = self.operand
      operand.respond_to?(:call) ? operand.call(tuple) : operand
    end

  end # class Aggregate
end # module Veritas