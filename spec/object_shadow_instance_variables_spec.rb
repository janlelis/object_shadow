require_relative "../lib/object_shadow"
require "minitest/autorun"

describe "Object#shadow" do
  let :c do
    Class.new do
      def initialize
        @ivar = 42
        @another_variable = 43
      end
    end
  end

  let :o do
    c.new
  end

  describe "#variables" do
    it "shows list of instance variable names" do
      assert_equal \
        [:ivar, :another_variable],
        o.shadow.variables
    end
  end

  describe "#variable?" do
    it "returns true if variable is defined" do
      assert \
        o.shadow.variable?(:ivar)
    end

    it "returns false if variable is not defined" do
      refute \
        o.shadow.variable?(:ovar)
    end
  end

  describe "#[]" do
    it "returns value of given instance variable name" do
      assert_equal \
        42,
        o.shadow[:ivar]
    end
  end

  describe "#[]=" do
    it "sets value of given instance variable name" do
      o.shadow[:ivar] = 1
      assert_equal \
        1,
        o.instance_variable_get(:@ivar)
    end
  end

  describe "to_h" do
    it "returns hash of all instance variables" do
      assert_equal(
        { ivar: 42, another_variable: 43 },
        o.shadow.to_h
      )
    end
  end

  describe "to_a" do
    it "returns array of all instance variable values" do
      assert_equal \
        [42, 43],
        o.shadow.to_a
    end
  end
end
