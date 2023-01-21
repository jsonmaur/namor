defmodule Namor.HelpersTest do
  use ExUnit.Case
  use Namor

  alias Namor.Helpers

  describe "get_dict/2" do
    test "should read reserved dict file" do
      dict = Helpers.get_dict(:reserved, Path.expand("../dict", __DIR__))
      assert dict == ["foobar"]
    end

    test "should read all 3 dict files" do
      dict = Helpers.get_dict(:custom, Path.expand("../dict", __DIR__))

      assert dict.adjective == ["one", "two"]
      assert dict.noun == ["three", "four"]
      assert dict.verb == ["five", "six"]
    end

    test "should raise error if dict files are not found" do
      assert_raise File.Error, fn -> Helpers.get_dict(:custom, "") end
    end
  end

  describe "get_pattern/1" do
    test "should return pattern for 1-4 words" do
      assert Helpers.get_pattern(1) |> Enum.count() == 1
      assert Helpers.get_pattern(2) |> Enum.count() == 2
      assert Helpers.get_pattern(3) |> Enum.count() == 3
      assert Helpers.get_pattern(4) |> Enum.count() == 4
    end

    test "should raise with incorrect params" do
      assert_raise FunctionClauseError, fn -> Helpers.get_pattern(0) end
      assert_raise FunctionClauseError, fn -> Helpers.get_pattern(5) end
      assert_raise FunctionClauseError, fn -> Helpers.get_pattern("5") end
    end
  end

  describe "get_salt/1" do
    test "should generate a salt" do
      assert Helpers.get_salt(5, 'abc123') =~ ~r/^[abc123]{5}$/
    end

    test "should raise with incorrect params" do
      assert_raise FunctionClauseError, fn -> Helpers.get_salt(0, 'a') end
      assert_raise FunctionClauseError, fn -> Helpers.get_salt("5", 'a') end
    end
  end
end
