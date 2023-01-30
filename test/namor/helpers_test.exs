defmodule Namor.HelpersTest do
  use ExUnit.Case

  alias Namor.Helpers

  describe "get_dict!/2" do
    setup do
      %{base_path: Path.expand("../dict", __DIR__)}
    end

    test "should read all dict files", %{base_path: base_path} do
      dict = Helpers.get_dict!(:custom, base_path)

      assert dict.adjectives == ["one", "two"]
      assert dict.nouns == ["three", "four"]
      assert dict.verbs == ["five", "six"]
    end

    test "should read reserved dict file", %{base_path: base_path} do
      dict = Helpers.get_dict!("reserved.txt", base_path)
      assert dict == ["foobar"]
    end

    test "should raise error if dict files are not found" do
      assert_raise File.Error, fn -> Helpers.get_dict!(:custom, "") end
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
