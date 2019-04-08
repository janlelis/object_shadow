# frozen_string_literal: true

class ObjectShadow
  module InfoInspect
    def inspect
      public_methods = methods(scope: :public)
      protected_methods = methods(scope: :protected)
      private_methods = methods(scope: :private)

      inherit_till = object.instance_of?(Object) ? :all : Object
      lookup_chain = method_lookup_chain(inherit: inherit_till).join(" →  ") + " →  …"

      res = \
        "# ObjectShadow of Object #%{object_id}\n\n" \
        "## Lookup Chain\n\n%{method_lookup_chain}\n\n"

      unless variables.empty?
        res += "## %{variables_count} Instance Variable%{variables_plural}\n\n%{variables}\n\n" \
      end

      unless public_methods.empty?
        res += "## %{public_methods_count} Public Method%{public_methods_plural} (Non-Class/Object)\n\n%{public_methods}\n\n" \
      end

      unless protected_methods.empty?
        res += "## %{protected_methods_count} Protected Method%{protected_methods_plural} (Non-Class/Object)\n\n%{protected_methods}\n\n" \
      end

      unless private_methods.empty?
        res += "## %{private_methods_count} Private Method%{private_methods_plural} (Non-Class/Object)\n\n%{private_methods}\n\n" \
      end

      res % {
        object_id: object.object_id,
        method_lookup_chain: InfoInspect.column100(lookup_chain),
        variables_count: variables.size,
        variables_plural: variables.size == 1 ? "" : "s",
        variables: InfoInspect.column100(variables.inspect),
        public_methods_count: public_methods.size,
        public_methods_plural: public_methods.size == 1 ? "" : "s",
        public_methods: InfoInspect.column100(public_methods.inspect),
        protected_methods_count: protected_methods.size,
        protected_methods_plural: protected_methods.size == 1 ? "" : "s",
        protected_methods: InfoInspect.column100(protected_methods.inspect),
        private_methods_count: private_methods.size,
        private_methods_plural: private_methods.size == 1 ? "" : "s",
        private_methods: InfoInspect.column100(private_methods.inspect),
      }
    end

    class << self
      def column100(input)
        words = input.split(" ")
        lines = [""]
        words.each{ |word|
          if lines[-1].size + word.size < 95 # 95 + 1 word space + 4 indent spaces = 95
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
