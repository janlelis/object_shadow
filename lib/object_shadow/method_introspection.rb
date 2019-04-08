# frozen_string_literal: true

class ObjectShadow
  module MethodIntrospection
    # #shadow#methods returns a sorted list of methods related to the object
    # in question. It lets you specify the kind of methods you want to retrieve
    # by the following keyword parameters:
    #
    # target: (default :self)
    #
    # - :self - This returns the list of methods available to call
    #           on the current object, including singleton methods
    #           If the object is a class/module, this means that it
    #           will return class methods
    #
    # - :class - This will refer to the object's class (via the `class`) method
    #            and return its methods, usually to be called from an instance
    #            If called for a class or module, it will return `Class`' methods
    #
    # - :instances - This will list all methods which instances of the class (or the class
    #                that includes the module, in case of a module) in question will have
    #                Raises an ArgumentError when called on with a non-`Module`
    #
    #
    # scope: (default :public)
    #
    # - :public - Restrict to to methods of public visibility
    #
    # - :protected - Restrict to to methods of protected visibility
    #
    # - :private - Restrict to to methods of private visibility
    #
    # - :all - Restrict to to methods of public visibility
    #
    #
    # inherit: (default :exclude_object)
    #
    # - :singleton - Show only methods directly defined in the object's singleton class
    #
    # - :self  - Show singleton methods and methods directly defined in the object's class,
    #            but do not traverse the inheritance chain
    #
    # - :exclude_class - Stop inheritance chain just before Class or Module. For
    #                    non-modules it fallbacks to :exclude_object
    #
    # - :exclude_object - Stop inheritance chain just before Object
    #
    # - :all - Show methods from the whole inheritance chain
    #
    def methods(target: :self, scope: :public, inherit: :exclude_class)
      MethodIntrospection.lookup_chain_for(object, target, inherit, true).flat_map { |lookup_class|
        full_inheritance_lookup = inherit == :all || inherit == true

        case scope
        when :public
          lookup_class.public_instance_methods(full_inheritance_lookup)
        when :protected
          lookup_class.protected_instance_methods(full_inheritance_lookup)
        when :private
          lookup_class.private_instance_methods(full_inheritance_lookup)
        when :all
          lookup_class.instance_methods(full_inheritance_lookup) +
          lookup_class.private_instance_methods(full_inheritance_lookup)
        else
          Kernel.raise ArgumentError, \
            "(ObjectShadow) Method scope: must be one of [:public, :protected, :private, :all]"
        end
      }.uniq.sort
    end

    # Returns true if a method of this name is defined
    # First parameter is the name of the method in question
    #
    # - target: must be one of [:self, :class, :instances]
    #
    def method?(method_name, target: :self)
      MethodIntrospection.simple_lookup_chain_for(object, target).any?{ |lookup_class|
        if RUBY_VERSION >= "2.6.0"
          lookup_class.method_defined?(method_name, true) ||
          lookup_class.private_method_defined?(method_name, true)
        else
          lookup_class.method_defined?(method_name) ||
          lookup_class.private_method_defined?(method_name)
        end
      }
    end

    # Returns the scope of method name given
    #
    # - target: must be one of [:self, :class, :instances]
    #
    # Possible return values: [:public, :protected, :private, nil]
    #
    def method_scope(method_name, target: :self)
      MethodIntrospection.simple_lookup_chain_for(object, target).map{ |lookup_class|
        if RUBY_VERSION >= "2.6.0"
          case
          when lookup_class.public_method_defined?(method_name, true)
            :public
          when lookup_class.protected_method_defined?(method_name, true)
            :protected
          when lookup_class.private_method_defined?(method_name, true)
            :private
          else
            nil
          end
        else
          case
          when lookup_class.public_method_defined?(method_name)
            :public
          when lookup_class.protected_method_defined?(method_name)
            :protected
          when lookup_class.private_method_defined?(method_name)
            :private
          else
            nil
          end
        end
      }.compact.first
    end

    # Returns the objectified reference to a method
    #
    # - target: must be one of [:self, :class, :instances]
    #
    # Pass unbind: true if you always want UnboundMethod objects
    #
    # Pass all: true to not only get the method that would be called,
    # but an Array with every occurrence of this method along the inheritance chain
    def method(method_name, target: :self, unbind: false, all: false)
      if all
        MethodIntrospection.lookup_chain_for(object, target, :all).map{ |lookup_class|
          if  lookup_class.instance_methods(false).include?(method_name) ||
              lookup_class.private_instance_methods(false).include?(method_name)
            lookup_class.instance_method(method_name)
          end
        }.compact
      else
        MethodIntrospection.get_method(object, target, method_name, unbind)
      end
    end

    # Returns the lookup/ancestor chain for an object
    #
    # - target: must be one of [:self, :class, :instances]
    #
    # Takes the same inherit options like #methods
    def method_lookup_chain(target: :self, inherit: :exclude_class)
      MethodIntrospection.lookup_chain_for(object, target, inherit)
    end

    class << self
      def lookup_chain_for(object, target, inherit, optimize = false)
        validate_arguments! object, target, inherit
        singleton, klass, chain = get_singleton_klass_and_chain(object, target)

        case inherit
        when :singleton
          singleton
        when :self, false
          singleton + klass
        when :exclude_class
          singleton + chain[0...(chain.index(Class) || chain.index(Module) || chain.index(Object))]
        when :exclude_object
          singleton + chain[0...chain.index(Object)]
        when Module
          singleton + chain[0..chain.index(inherit)]
        when :all, true
          if optimize # full chain build by Ruby using (all=true) param in list
            singleton + klass
          else
            singleton + chain
          end
        end
      end

      def simple_lookup_chain_for(object, target)
        validate_arguments! object, target
        singleton, klass, = get_singleton_klass_and_chain(object, target)

        singleton + klass
      end

      def get_method(object, target, method_name, unbind)
        case target
        when :self
          if unbind
            object.method(method_name).unbind()
          else
            object.method(method_name)
          end
        when :class
          if unbind
            object.class.method(method_name).unbind()
          else
            object.class.method(method_name)
          end
        when :instances
          object.instance_method(method_name)
        else
          Kernel.raise ArgumentError, "(ObjectShadow) target: must be one of [:self, :class, :instances]"
        end
      rescue NameError
        nil
      end

      private

      # Explanation:
      # - singleton: [singleton_class] or [] if not retrievable
      # - klass: [first entry of inheritance chain] or [] for modules
      # - chain: inheritance chain without singleton
      def get_singleton_klass_and_chain(object, target)
        target_object = target == :class ? object.class : object

        begin
          if target == :instances
            singleton = []
            klass = target_object.ancestors[0, 1]
            chain = target_object.ancestors
          else
            singleton = [target_object.singleton_class]

            if target_object.is_a? Module
              klass = []
              chain = target_object.singleton_class.ancestors[1..-1]
            else
              klass = target_object.singleton_class.ancestors[1, 1]
              chain = target_object.singleton_class.ancestors[1..-1]
            end
          end
        rescue TypeError # e.g. Integer
          singleton = []
          klass = target_object.class.ancestors[0, 1]
          chain = target_object.class.ancestors
        end

        [singleton, klass, chain]
      end

      def validate_arguments!(object, target, inherit = nil)
        unless [:self, :class, :instances].include?(target)
          Kernel.raise ArgumentError, "(ObjectShadow) target: must be one of [:self, :class, :instances]"
        end

        if target == :instances
          if !object.is_a?(Module)
            Kernel.raise ArgumentError, "(ObjectShadow) target: can only be set to :instances for classes and modules"
          end

          if inherit == :singleton
            Kernel.raise ArgumentError, "(ObjectShadow) cannot request :singleton inheritance when target is :instances"
          end
        end
      end
    end
  end
end
