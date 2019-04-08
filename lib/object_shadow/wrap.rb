# frozen_string_literal: true

class ObjectShadow
  module Wrap
    attr_reader :object

    def initialize(object)
      @object = object
    end

    # Since shadows are not supposed to be passed around, to_s is left neutral
    def to_s
      "#<ObjectShadow of #{object.inspect}>"
    end

    # The base inspect is boring, too, but it will be improved by InfoInspect
    alias inspect to_s
  end
end
