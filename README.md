# Object#shadow [![[version]](https://badge.fury.io/rb/object_shadow.svg)](https://badge.fury.io/rb/object_shadow)  [![[ci]](https://github.com/janlelis/object_shadow/workflows/Test/badge.svg)](https://github.com/janlelis/object_shadow/actions?query=workflow%3ATest)

Have you ever been [confused by some of Ruby's meta-programming methods?](https://idiosyncratic-ruby.com/25-meta-methodology.html)

If your answer is *Yes*, you have come to the right place:

![Object and Shadow](/object_shadow.png)

With **shadow**, every Ruby object has a shadow which provides a clean API to access the object's variables and methods.

Never again you will have to do the `x.methods - Object.methods` trick to get a meaningful method list.

## Setup

Add to your `Gemfile`:

```ruby
gem "object_shadow"
```

## Usage Example

```ruby
class P
  def a_public_parent_method
  end
end

class C < P
  def initialize
    @ivar = 42
    @another_variable = 43
  end

  attr_reader :another_variable

  def a_public_method
  end

  protected

  def a_protected_method
  end

  private

  def a_private_method
  end
end

object = C.new

def object.a_public_singleton_method
end
```

### # Get an Overview

```ruby
require "object_shadow"
object.shadow # ObjectShadow of Object #47023274596520

## Lookup Chain

    #<Class:#<C:0x00005588eb283150>> → C → P → Object → …

## 2 Instance Variables

    [:ivar, :another_variable]

## 4 Public Methods (Non-Class/Object)

    [:a_public_method, :a_public_parent_method, :a_public_singleton_method, :another_variable]

## 1 Protected Method (Non-Class/Object)

    [:a_protected_method]

## 2 Private Methods (Non-Class/Object)

    [:a_private_method, :initialize]

```

### # Read & Manipulate Instance Variables

```ruby
object.shadow[:ivar] # => 42
object.shadow[:another_variable] = 23; object.another_variable # => 23
object.shadow.variables # => [:ivar, :another_variable]
object.shadow.to_h # => {:ivar=>42, :another_variable=>23}
object.shadow.remove(:ivar) # => 42 (and removed)
```

### # List Available Methods

```ruby
# shadow features a single method called `methods` which takes some keyword arguments for further listing options
object.shadow.methods # => [:a_public_method, :a_public_parent_method, :a_public_singleton_method, :another_variable]

# Use scope: option to toggle visibility (default is public)
object.shadow.methods(scope: :public) # => [:a_public_method, :a_public_parent_method, :a_public_singleton_method, :another_variable]
object.shadow.methods(scope: :protected) # => [:a_protected_method]
object.shadow.methods(scope: :private) # => [:a_private_method, :initialize]
object.shadow.methods(scope: :all) # => [:a_private_method, :a_protected_method, :a_public_method, :a_public_parent_method, :a_public_singleton_method, :another_variable, :initialize]

# Use inherit: option to allow or prevent traversal of the inheritance chain
object.shadow.methods(scope: :public, inherit: :singleton) # => [:a_public_singleton_method]
object.shadow.methods(scope: :public, inherit: :self) # => [:a_public_method, :a_public_singleton_method, :another_variable]
object.shadow.methods(scope: :public, inherit: :exclude_object) # => [:a_public_method, :a_public_parent_method, :a_public_singleton_method, :another_variable]
object.shadow.methods(scope: :public, inherit: :all) # => [:!, :!=, :!~, :<=>, :==, :===, :=~, :__id__, :__send__, :a_public_method, :a_public_parent_method, :a_public_singleton_method, :another_variable, :class, :clone, :define_singleton_method, :display, :dup, :enum_for, :eql?, :equal?, :extend, :freeze, :frozen?, :hash, :inspect, :instance_eval, :instance_exec, :instance_of?, :instance_variable_defined?, :instance_variable_get, :instance_variable_set, :instance_variables, :is_a?, :itself, :kind_of?, :method, :methods, :nil?, :object_id, :private_methods, :protected_methods, :public_method, :public_methods, :public_send, :remove_instance_variable, :respond_to?, :send, :shadow, :singleton_class, :singleton_method, :singleton_methods, :taint, :tainted?, :tap, :then, :to_enum, :to_s, :trust, :untaint, :untrust, :untrusted?, :yield_self]

# Use target: :instances or :class to jump between child and class method listings
C.shadow.methods == C.new.shadow.methods(target: :class) #=> true
C.shadow.methods(target: :instances) == C.new.shadow.methods #=> true
Enumerable.shadow.methods(target: :instances) # (lists Enumerables' methods)
```

## Documentation

### Instance Variables

Shadow exposes instance variables in a Hash-like manner:

Method     | Description
-----------|------------
`[]`       | Retrieve instance variables. Takes a symbol without `@` to identify variable.
`[]=`      | Sets instance variables. Takes a symbol without `@` to identify variable.
`remove`   | Removes an instance variables. Takes a symbol without `@` to identify variable.
`variable?`| Checks if a variable with that name exists. Takes a symbol without `@` to identify variable.
`variables`| Returns the list of instance variables as symbols without `@`.
`to_h`     | Returns a hash of instance variable names with `@`-less variables names as the keys.
`to_a`     | Returns an array of all instance variable values.

### Method Introspection

All method introspection methods get called on the shadow and take a `target:` keyword argument, which defaults to `:self`. It can take one of the following values:

Value of `target:` | Meaning
-------------------|--------
`:self`            | Operate on the current object
`:class`           | Operate on the current object's class (the class for instances, the singleton class for classes)
`:instances`       | Operate on potential instances created by the object, which is a class (or module)

#### `methods(target: :self, scope: :public, inherit: :exclude_class)`

Returns a list of methods available to the object.

Only shows methods matching the given `scope:`, i.e. when you request all **public** methods, **protected** and **private** methods will not be included. You can also pass in `:all` to get methods of *all* scopes.

The `inherit:` option lets you choose how deep you want to dive into the inheritance chain:

Value of `inherit:` | Meaning
--------------------|--------
`:singleton`        | Show only methods directly defined in the object's singleton class
`:self`             | Show singleton methods and methods directly defined in the object's class, but do not traverse the inheritance chain
`:exclude_class`    | Stop inheritance chain just before Class or Module. For non-modules it fallbacks to `:exclude_object`
`:exclude_object`   | Stop inheritance chain just before Object
`:all`              | Show methods from the whole inheritance chain

#### `method?(method_name, target: :self)`

Returns `true` if such a method can be found, `false` otherwise

#### `method_scope(method_name, target: :self)`

Returns the visibility scope of the method in question, one of `:public`, `:protected`, `:private`. If the method cannot be located, returns `nil`.

#### `method(method_name, target: :self, unbind: false, all: false)`

Returns the `Method` or `UnboundMethod` object of the method requested. Use `unbind: true` to force the return value to be an `UnboundMethod` object. Will always return `UnboundMethod`s if used in conjunction with `target: :instances`.

If you pass in `all: true`, it will return an array of all (unbound) method objects found in the inheritance chain for the given method name.

#### `method_lookup_chain(target: :self, inherit: :exclude_class)`

Shows the lookup chain for the target. See `methods()` for description of the `inherit:` option.

## Q & A

### Can I Access Hidden Instance Variables?

Some of Ruby's core classes use `@`-less instance variables, such as [Structs](https://ruby-doc.org/core/Struct.html). They cannot be accessed using shadow.

### Does It Support Refinements?

[Currently not.](https://ruby-doc.org/core/doc/syntax/refinements_rdoc.html#label-Methods+Introspection)

### Other Meta Programming?

Only some aspects of Ruby meta-programming are covered. However, **shadow** aims to cover all kinds of meta-programming. Maybe you have an idea about how to integrate `eval`, `method_missing`, and friends?

### Does this Gem Include a Secret Mode which Activates an Improved Shadow Inspect?

Yes, run the following command.

```ruby
ObjectShadow.include(ObjectShadow::DeepInspect)
42.shadow
```

Requires the following gems: **paint**, **wirb**, **io-console**


## J-_-L

Copyright (C) 2019-2021 Jan Lelis <https://janlelis.com>. Released under the MIT license.

PS: This gem would not exist if the [instance gem](https://rubyworks.github.io/instance/) did not come up with the idea.
