# frozen_string_literal: true

require_relative "object_shadow/basic_object"
require_relative "object_shadow/version"
require_relative "object_shadow/object_method"

require_relative "object_shadow/wrap"
require_relative "object_shadow/instance_variables"
require_relative "object_shadow/method_introspection"
require_relative "object_shadow/info_inspect"
require_relative "object_shadow/deep_inspect"

class ObjectShadow
  include Wrap
  include InstanceVariables
  include MethodIntrospection
  include InfoInspect
end