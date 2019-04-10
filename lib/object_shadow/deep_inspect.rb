# frozen_string_literal: true

begin
  require "paint"
  require "wirb"
  require "io/console"
rescue LoadError
  warn "Not loading ObjectShadow::DeepInspect (required gems missing/not bundled)"
end

class ObjectShadow
  # Improve shadow#inspect
  # Optional, because it requires the following gems to be installed:
  # - paint
  # - wirb
  # - io-console
  module DeepInspect
    def inspect
      public_methods = methods(scope: :public)
      protected_methods = methods(scope: :protected)
      private_methods = methods(scope: :private)

      inherit_till = object.instance_of?(Object) ? :all : Object
      lookup_chain = (method_lookup_chain(inherit: inherit_till) + ["…"]).inspect

      res = \
        Paint["# ObjectShadow of Object #%{object_id}\n\n", :underline] +
        Paint["## Lookup Chain\n\n", :bold] +
        "%{method_lookup_chain}\n\n"

      unless variables.empty?
        res += Paint["## %{variables_count} Instance Variable%{variables_plural}\n\n%{variables}\n\n", :bold]
      end

      unless public_methods.empty?
        res += Paint["## %{public_methods_count} Public Method%{public_methods_plural} (Non-Class/Object)\n\n%{public_methods}\n\n", :bold]
      end

      unless protected_methods.empty?
        res += Paint["## %{protected_methods_count} Protected Method%{protected_methods_plural} (Non-Class/Object)\n\n%{protected_methods}\n\n", :bold]
      end

      unless private_methods.empty?
        res += Paint["## %{private_methods_count} Private Method%{private_methods_plural} (Non-Class/Object)\n\n%{private_methods}\n\n", :bold]
      end

      res += \
        Paint["## Object Inspect\n\n", :bold] +
        "%{object_inspect}\n\n"

      res % {
        object_id: object.object_id,
        method_lookup_chain: ::Wirb.colorize_result(DeepInspect.column100(lookup_chain)),
        variables_count: variables.size,
        variables_plural: variables.size == 1 ? "" : "s",
        variables: ::Wirb.colorize_result(DeepInspect.column100(variables.inspect)),
        public_methods_count: public_methods.size,
        public_methods_plural: public_methods.size == 1 ? "" : "s",
        public_methods: ::Wirb.colorize_result(DeepInspect.column100(public_methods.inspect)),
        protected_methods_count: protected_methods.size,
        protected_methods_plural: protected_methods.size == 1 ? "" : "s",
        protected_methods: ::Wirb.colorize_result(DeepInspect.column100(protected_methods.inspect)),
        private_methods_count: private_methods.size,
        private_methods_plural: private_methods.size == 1 ? "" : "s",
        private_methods: ::Wirb.colorize_result(DeepInspect.column100(private_methods.inspect)),
        object_inspect: ::Wirb.colorize_result(DeepInspect.column100(object.inspect))
      }
    end

    class << self
      def column100(input)
        terminal_size = STDOUT.winsize[1] || 100
        words = input.split(" ")
        lines = [""]
        words.each{ |word|
          if lines[-1].size + word.size < terminal_size - 9 # x - 1 word space - 4 indent spaces x2
            lines[-1] = lines[-1] + word + " "
          else
            lines << word + " "
          end
        }

        lines.map{ |line|
          "    #{line}"
        }.join("\n")
      end
    end
  end
end
