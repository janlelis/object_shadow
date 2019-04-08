# frozen_string_literal: true

class ObjectShadow
  module InstanceVariables
    # Returns the instance variable given
    # Please note: Does not expect @ prefix
    def [](ivar_name)
      object.instance_variable_get(:"@#{ivar_name}")
    end

    # Sets the instance variable given
    # Please note: Does not expect @ prefix
    def []=(ivar_name, value)
      object.instance_variable_set(:"@#{ivar_name}", value)
    end

    def remove(ivar_name)
      object.remove_instance_variable(:"@#{ivar_name}")
    end

    def variable?(ivar_name)
      object.instance_variable_defined?(:"@#{ivar_name}")
    end

    def variables
      object.instance_variables.map{ |ivar| ivar[1..-1].to_sym }
    end

    def to_h
      variables.map{ |ivar| [ivar, self[ivar]] }.to_h
    end

    def to_a
      variables.map{ |ivar| self[ivar] }
    end
  end
end