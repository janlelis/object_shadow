# frozen_string_literal: true

class ObjectShadow < BasicObject
  def class
    ::ObjectShadow
  end

  def respond_to?(what)
    ::ObjectShadow.instance_methods.include?(what)
  end

  def instance_of?(other)
    other == ::ObjectShadow
  end

  def is_a?(other)
    other.ancestors.include? ::ObjectShadow
  end

  def singleton_class
    class << self; self end
  end
end
