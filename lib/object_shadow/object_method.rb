# frozen_string_literal: true

class ObjectShadow
  module ObjectMethod
    def shadow
      ObjectShadow.new(self)
    end
  end
end

Object.include(ObjectShadow::ObjectMethod)
