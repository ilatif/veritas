module Veritas
  class Relation
    class Empty < Relation
      include Optimizable  # for no-op #optimize

      def initialize(header)
        super(header, [])
      end

    end # class Empty
  end # class Relation
end # module Veritas
