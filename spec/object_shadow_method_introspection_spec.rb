require_relative "../lib/object_shadow"
require "minitest/autorun"

describe "Object#shadow" do
  let :astronomical_body do
    Class.new do
      def fly
      end

      protected

      def crash
      end

      private

      def explode
      end


      class << self
        def make
        end

        protected

        def stir
        end

        private

        def idea
        end
      end
    end
  end

  let :planet do
    Class.new(astronomical_body) do
      def rotate
      end

      protected

      def bump
      end

      private

      def implode
      end

      class << self
        def construct
        end

        protected

        def prepare
        end

        private

        def think
        end
      end
    end
  end

  let :earth do
    earth = planet.new

    class << earth
      def develop
      end

      protected

      def magnetize
      end

      private

      def repair
      end
    end

    earth
  end


  describe "#methods" do
    describe "[target: :self]" do
      describe "[scope: :public]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:develop],
              earth.shadow.methods(target: :self, scope: :public, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:develop, :rotate],
              earth.shadow.methods(target: :self, scope: :public, inherit: :self)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:develop, :fly, :rotate],
              earth.shadow.methods(target: :self, scope: :public, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:develop, :fly, :rotate],
              earth.shadow.methods(target: :self, scope: :public, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:develop, :fly, :rotate] +
                Object.public_instance_methods
              ).sort,
              earth.shadow.methods(target: :self, scope: :public, inherit: :all)
          end
        end
      end

      describe "[scope: :protected]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:magnetize],
              earth.shadow.methods(target: :self, scope: :protected, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:bump, :magnetize],
              earth.shadow.methods(target: :self, scope: :protected, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :magnetize],
              earth.shadow.methods(target: :self, scope: :protected, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :magnetize],
              earth.shadow.methods(target: :self, scope: :protected, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :magnetize],
              earth.shadow.methods(target: :self, scope: :protected, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:bump, :crash, :magnetize] +
                Object.protected_instance_methods
              ).sort,
              earth.shadow.methods(target: :self, scope: :protected, inherit: :all)
          end
        end
      end

      describe "[scope: :private]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:repair],
              earth.shadow.methods(target: :self, scope: :private, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:implode, :repair],
              earth.shadow.methods(target: :self, scope: :private, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              [:explode, :implode, :repair],
              earth.shadow.methods(target: :self, scope: :private, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:explode, :implode, :repair],
              earth.shadow.methods(target: :self, scope: :private, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:explode, :implode, :repair],
              earth.shadow.methods(target: :self, scope: :private, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:explode, :implode, :repair] +
                Object.private_instance_methods
              ).sort,
              earth.shadow.methods(target: :self, scope: :private, inherit: :all)
          end
        end
      end

      describe "[scope: :all]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:develop, :magnetize, :repair],
              earth.shadow.methods(target: :self, scope: :all, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:bump, :develop, :implode, :magnetize, :repair, :rotate],
              earth.shadow.methods(target: :self, scope: :all, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :develop, :explode, :fly, :implode, :magnetize, :repair, :rotate],
              earth.shadow.methods(target: :self, scope: :all, inherit: :exclude_object)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :develop, :explode, :fly, :implode, :magnetize, :repair, :rotate],
              earth.shadow.methods(target: :self, scope: :all, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :develop, :explode, :fly, :implode, :magnetize, :repair, :rotate],
              earth.shadow.methods(target: :self, scope: :all, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:bump, :crash, :develop, :explode, :fly, :implode, :magnetize, :repair, :rotate] +
                Object.instance_methods +
                Object.private_instance_methods
              ).sort,
              earth.shadow.methods(target: :self, scope: :all, inherit: :all)
          end
        end
      end
    end


    describe "[target: :class]" do
      describe "[scope: :public]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:construct],
              earth.shadow.methods(target: :class, scope: :public, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:construct],
              earth.shadow.methods(target: :class, scope: :public, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :make] +
                Object.singleton_class.public_instance_methods(false) +
                BasicObject.singleton_class.public_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :public, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :make] +
                Object.singleton_class.public_instance_methods(false) +
                BasicObject.singleton_class.public_instance_methods(false) +
                Class.public_instance_methods(false) +
                Module.public_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :public, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :make] +
                Object.singleton_class.public_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :public, inherit: Object.singleton_class)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :make] +
                Object.singleton_class.public_instance_methods(true)
              ).sort,
              earth.shadow.methods(target: :class, scope: :public, inherit: :all)
          end
        end
      end

      describe "[scope: :protected]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:prepare],
              earth.shadow.methods(target: :class, scope: :protected, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:prepare],
              earth.shadow.methods(target: :class, scope: :protected, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              (
                [:prepare, :stir] +
                Object.singleton_class.protected_instance_methods(false) +
                BasicObject.singleton_class.protected_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :protected, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              (
                [:prepare, :stir] +
                Object.singleton_class.protected_instance_methods(false) +
                BasicObject.singleton_class.protected_instance_methods(false) +
                Class.protected_instance_methods(false) +
                Module.protected_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :protected, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              (
                [:prepare, :stir] +
                Object.singleton_class.protected_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :protected, inherit: Object.singleton_class)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:prepare, :stir] +
                Object.singleton_class.protected_instance_methods(true)
              ).sort,
              earth.shadow.methods(target: :class, scope: :protected, inherit: :all)
          end
        end
      end

      describe "[scope: :private]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:think],
              earth.shadow.methods(target: :class, scope: :private, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:think],
              earth.shadow.methods(target: :class, scope: :private, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              (
                [:think, :idea] +
                Object.singleton_class.private_instance_methods(false) +
                BasicObject.singleton_class.private_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :private, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              (
                [:think, :idea] +
                Object.singleton_class.private_instance_methods(false) +
                BasicObject.singleton_class.private_instance_methods(false) +
                Class.private_instance_methods(false) +
                Module.private_instance_methods(false)
              ).uniq.sort,
              earth.shadow.methods(target: :class, scope: :private, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              (
                [:think, :idea] +
                Object.singleton_class.private_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :private, inherit: Object.singleton_class)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:think, :idea] +
                Object.singleton_class.private_instance_methods(true)
              ).sort,
              earth.shadow.methods(target: :class, scope: :private, inherit: :all)
          end
        end
      end

      describe "[scope: :all]" do
        describe "[inherit: :singleton]" do
          it "✓" do
            assert_equal \
              [:construct, :prepare, :think],
              earth.shadow.methods(target: :class, scope: :all, inherit: :singleton)
          end
        end

        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:construct, :prepare, :think],
              earth.shadow.methods(target: :class, scope: :all, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :idea, :make, :prepare, :stir, :think] +
                Object.singleton_class.instance_methods(false) +
                Object.singleton_class.private_instance_methods(false) +
                BasicObject.singleton_class.instance_methods(false) +
                BasicObject.singleton_class.private_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :all, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :idea, :make, :prepare, :stir, :think] +
                Object.singleton_class.instance_methods(false) +
                Object.singleton_class.private_instance_methods(false) +
                BasicObject.singleton_class.instance_methods(false) +
                BasicObject.singleton_class.private_instance_methods(false) +
                Class.instance_methods(false) +
                Class.private_instance_methods(false) +
                Module.instance_methods(false) +
                Module.private_instance_methods(false)
              ).uniq.sort,
              earth.shadow.methods(target: :class, scope: :all, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :idea, :make, :prepare, :stir, :think] +
                Object.singleton_class.instance_methods(false) +
                Object.singleton_class.private_instance_methods(false)
              ).sort,
              earth.shadow.methods(target: :class, scope: :all, inherit: Object.singleton_class)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:construct, :idea, :make, :prepare, :stir, :think] +
                Object.singleton_class.instance_methods(true) +
                Object.singleton_class.private_instance_methods(true)
              ).sort,
              earth.shadow.methods(target: :class, scope: :all, inherit: :all)
          end
        end
      end
    end


    describe "[target: :instances]" do
      describe "context: called for a non-module" do
        it "✗ will raise an ArgumentError" do
          assert_raises(ArgumentError) {
            earth.shadow.methods(target: :instances)
          }
        end
      end

      describe "[inherit: :singleton]" do
        it "✗ will raise an ArgumentError" do
          assert_raises(ArgumentError) {
            planet.shadow.methods(target: :instances, inherit: :singleton)
          }
        end
      end

      describe "[scope: :public]" do
        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:rotate],
              planet.shadow.methods(target: :instances, scope: :public, inherit: :self)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:fly, :rotate],
              planet.shadow.methods(target: :instances, scope: :public, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:fly, :rotate],
              planet.shadow.methods(target: :instances, scope: :public, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:fly, :rotate] +
                Object.public_instance_methods
              ).sort,
              planet.shadow.methods(target: :instances, scope: :public, inherit: :all)
          end
        end
      end

      describe "[scope: :protected]" do
        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:bump],
              planet.shadow.methods(target: :instances, scope: :protected, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              [:bump, :crash],
              planet.shadow.methods(target: :instances, scope: :protected, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:bump, :crash],
              planet.shadow.methods(target: :instances, scope: :protected, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:bump, :crash],
              planet.shadow.methods(target: :instances, scope: :protected, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:bump, :crash] +
                Object.protected_instance_methods
              ).sort,
              planet.shadow.methods(target: :instances, scope: :protected, inherit: :all)
          end
        end
      end

      describe "[scope: :private]" do
        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:implode],
              planet.shadow.methods(target: :instances, scope: :private, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              [:explode, :implode],
              planet.shadow.methods(target: :instances, scope: :private, inherit: :exclude_class)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:explode, :implode],
              planet.shadow.methods(target: :instances, scope: :private, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:explode, :implode],
              planet.shadow.methods(target: :instances, scope: :private, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:explode, :implode] +
                Object.private_instance_methods
              ).sort,
              planet.shadow.methods(target: :instances, scope: :private, inherit: :all)
          end
        end
      end

      describe "[scope: :all]" do
        describe "[inherit: :self, inherit: false]" do
          it "✓" do
            assert_equal \
              [:bump, :implode, :rotate],
              planet.shadow.methods(target: :instances, scope: :all, inherit: :self)
          end
        end

        describe "[inherit: :exclude_class]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :explode, :fly, :implode, :rotate],
              planet.shadow.methods(target: :instances, scope: :all, inherit: :exclude_object)
          end
        end

        describe "[inherit: :exclude_object]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :explode, :fly, :implode, :rotate],
              planet.shadow.methods(target: :instances, scope: :all, inherit: :exclude_object)
          end
        end

        describe "[inherit: Module]" do
          it "✓" do
            assert_equal \
              [:bump, :crash, :explode, :fly, :implode, :rotate],
              planet.shadow.methods(target: :instances, scope: :all, inherit: astronomical_body)
          end
        end

        describe "[inherit: :all, inherit: true]" do
          it "✓" do
            assert_equal \
              (
                [:bump, :crash, :explode, :fly, :implode, :rotate] +
                Object.instance_methods +
                Object.private_instance_methods
              ).sort,
              planet.shadow.methods(target: :instances, scope: :all, inherit: :all)
          end
        end
      end
    end
  end

  describe "#method?" do
    it "will return true if method exists" do
      assert earth.shadow.method?(:bump)
      assert earth.shadow.method?(:magnetize)
      assert earth.shadow.method?(:stir, target: :class)

      assert planet.shadow.method?(:idea)
      assert planet.shadow.method?(:implode, target: :instances)
    end

    it "will return false if method does not exist" do
      refute earth.shadow.method?(:idea)
      refute earth.shadow.method?(:idiosyncratic)
      refute earth.shadow.method?(:magnetize, target: :class)

      refute planet.shadow.method?(:rotate)
      refute planet.shadow.method?(:stir, target: :instances)
    end
  end

  describe "#method_scope" do
    it "will return :public for public methods" do
      assert_equal :public, earth.shadow.method_scope(:rotate)
      assert_equal :public, earth.shadow.method_scope(:develop)
      assert_equal :public, earth.shadow.method_scope(:make, target: :class)

      assert_equal :public, planet.shadow.method_scope(:construct)
      assert_equal :public, planet.shadow.method_scope(:rotate, target: :instances)
    end

    it "will return :protected for protected methods" do
      assert_equal :protected, earth.shadow.method_scope(:bump)
      assert_equal :protected, earth.shadow.method_scope(:magnetize)
      assert_equal :protected, earth.shadow.method_scope(:stir, target: :class)

      assert_equal :protected, planet.shadow.method_scope(:prepare)
      assert_equal :protected, planet.shadow.method_scope(:bump, target: :instances)
    end

    it "will return :private for private methods" do
      assert_equal :private, earth.shadow.method_scope(:implode)
      assert_equal :private, earth.shadow.method_scope(:repair)
      assert_equal :private, earth.shadow.method_scope(:think, target: :class)

      assert_equal :private, planet.shadow.method_scope(:idea)
      assert_equal :private, planet.shadow.method_scope(:implode, target: :instances)
    end

    it "will return nil if method does not exist" do
      refute earth.shadow.method?(:idea)
      refute earth.shadow.method?(:magnetize, target: :class)

      refute planet.shadow.method?(:rotate)
      refute planet.shadow.method?(:stir, target: :instances)
    end
  end

  describe "#method" do
    it "will return Method object" do
      assert_instance_of Method, earth.shadow.method(:bump)
      assert_instance_of Method, earth.shadow.method(:magnetize)
      assert_instance_of Method, earth.shadow.method(:stir, target: :class)

      assert_instance_of Method, planet.shadow.method(:idea)
    end

    it "will return UnboundMethod object for target: instances "do
      assert_instance_of UnboundMethod, planet.shadow.method(:implode, target: :instances)
    end

    it "will return UnboundMethod object when unbind: true is passed" do
      assert_instance_of UnboundMethod, earth.shadow.method(:bump, unbind: true)
    end

    it "will return nil if method does not exist" do
      assert_nil earth.shadow.method(:fun)
    end


    it "returns an array of all (unbound) methods in the lookup chain if all: true is passed" do
      def earth.bump() end

      res = earth.shadow.method(:bump, all: true)
      assert_instance_of Array, res
      assert_instance_of UnboundMethod, res[0]
      assert_instance_of UnboundMethod, res[1]
    end
  end

  describe "#method_lookup_chain" do
    describe "[inherit: :exclude_class]" do
      it "shows the lookup chain (including singleton class) for non-classes, stops lookup chain before Class" do
        assert_equal \
          [earth.singleton_class, planet, astronomical_body],
          earth.shadow.method_lookup_chain
      end

      it "shows the lookup chain for classes, stops lookup chain before Class" do
        assert_equal \
          [
            planet,
            astronomical_body,
            Object,
            BasicObject,
          ].map(&:singleton_class),
          planet.shadow.method_lookup_chain
      end
    end

    describe "[inherit: :all]" do
      it "shows the lookup chain (including singleton class) for non-classes" do
        assert_equal \
          [
            earth.singleton_class,
            planet,
            astronomical_body,
            Object,
            Minitest::Expectations,
            ObjectShadow::ObjectMethod,
            Kernel,
            BasicObject,
          ],
          earth.shadow.method_lookup_chain(inherit: :all)
      end

      it "shows the lookup chain for classes" do
        assert_equal \
          [
            planet,
            astronomical_body,
            Object,
            BasicObject,
          ].map(&:singleton_class) + [
            Class,
            Module,
            Object,
            Minitest::Expectations,
            ObjectShadow::ObjectMethod,
            Kernel,
            BasicObject,
          ],
          planet.shadow.method_lookup_chain(inherit: :all)
      end
    end
  end
end

