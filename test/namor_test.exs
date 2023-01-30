defmodule NamorTest do
  use ExUnit.Case
  use Namor

  describe "get_dictionaries/0" do
    test "should get all dictionaries" do
      dictionaries = Namor.get_dictionaries()
      assert Map.has_key?(dictionaries, :default)
      assert Map.has_key?(dictionaries, :manly)
    end
  end

  describe "get_reserved/0" do
    test "should get reserved word list" do
      assert Namor.get_reserved() |> Enum.count() > 0
    end
  end

  describe "generate/1" do
    test "should generate a name" do
      assert {:ok, name} = Namor.generate()
      assert String.split(name, "-") |> Enum.count() == 2
    end

    test "should generate a name from default dictionary" do
      assert {:ok, name} = Namor.generate(words: 3)
      assert [adjective, _, _] = String.split(name, "-")
      assert Namor.Helpers.get_dict!(:default).adjectives |> Enum.member?(adjective)
    end

    test "should generate a name with an alternate dictionary" do
      assert {:ok, name} = Namor.generate(words: 3, dictionary: :manly)
      assert [adjective, _, _] = String.split(name, "-")
      assert Namor.Helpers.get_dict!(:manly).adjectives |> Enum.member?(adjective)
    end

    test "should return error if dictionary doesn't exist" do
      assert {:error, :dict_not_found} = Namor.generate(dictionary: :foobar)
    end
  end

  describe "generate/2" do
    setup do
      %{dict: Namor.Helpers.get_dict!(:custom, Path.expand("./dict", __DIR__))}
    end

    test "should generate a name", %{dict: dict} do
      assert {:ok, name} = Namor.generate([], dict)
      assert String.split(name, "-") |> Enum.count() == 2
      assert name =~ ~r/three|four/
    end

    test "should generate a name with 1 word", %{dict: dict} do
      assert {:ok, name} = Namor.generate([words: 1], dict)
      assert name =~ ~r/one|two|three|four|five|six/
      refute name =~ "-"
    end

    test "should generate a name with 3 words", %{dict: dict} do
      assert {:ok, name} = Namor.generate([words: 3], dict)
      assert String.split(name, "-") |> Enum.count() == 3
      assert name =~ ~r/(?:one|two)-(?:three|four)-(?:five|six)/
    end

    test "should generate a name with 4 words", %{dict: dict} do
      assert {:ok, name} = Namor.generate([words: 4], dict)
      assert String.split(name, "-") |> Enum.count() == 4
      assert name =~ ~r/(?:one|two)-(?:three|four)-(?:three|four)-(?:five|six)/
    end

    test "should max out at 4 words", %{dict: dict} do
      assert_raise FunctionClauseError, fn -> Namor.generate([words: 5], dict) end
    end

    test "should generate a name with a mixed salt", %{dict: dict} do
      assert {:ok, name} = Namor.generate([salt: 10], dict)
      assert [_, _, salt] = String.split(name, "-")
      assert salt =~ ~r/^[a-z0-9]{10}$/
    end

    test "should generate a name with a numeric salt", %{dict: dict} do
      assert {:ok, name} = Namor.generate([salt: 10, salt_type: :numbers], dict)
      assert [_, _, salt] = String.split(name, "-")
      assert salt =~ ~r/^[0-9]{10}$/
    end

    test "should generate a name with a letter salt", %{dict: dict} do
      assert {:ok, name} = Namor.generate([salt: 10, salt_type: :letters], dict)
      assert [_, _, salt] = String.split(name, "-")
      assert salt =~ ~r/^[a-z]{10}$/
    end

    test "should generate a name with a custom separator", %{dict: dict} do
      assert {:ok, name} = Namor.generate([separator: "_"], dict)
      assert String.split(name, "_") |> Enum.count() == 2
    end

    test "should not crash with a nil separator", %{dict: dict} do
      assert {:ok, name} = Namor.generate([separator: nil], dict)
      assert name =~ ~r/^[a-zA-Z]*$/
    end

    test "should raise with incorrect params" do
      assert_raise FunctionClauseError, fn -> Namor.generate([], "foo") end
    end
  end

  describe "with_salt/4" do
    test "should append a salt to a value" do
      assert Namor.with_salt("foobar", 5) =~ ~r/^foobar-[a-zA-Z0-9]{5}$/
    end

    test "should append a salt to a value with options" do
      assert Namor.with_salt("foobar", 5, "_", :numbers) =~ ~r/^foobar_[0-9]{5}$/
    end
  end

  describe "reserved?/1" do
    test "should invalidate a reserved subdomain from default reserved list" do
      assert Namor.reserved?("login")
      refute Namor.reserved?("foobar")
    end
  end

  describe "reserved?/2" do
    test "should invalidate a reserved subdomain" do
      base_path = Path.expand("./dict", __DIR__)
      reserved = Namor.Helpers.get_dict!("reserved.txt", base_path)

      assert Namor.reserved?("foobar", reserved)
      assert Namor.reserved?("foo-bar", reserved)
      assert Namor.reserved?("foo bar", reserved)
      assert Namor.reserved?("foo--bar", reserved)
      assert Namor.reserved?(" foo bar ", reserved)
      refute Namor.reserved?("login", reserved)
    end
  end

  describe "subdomain?/2" do
    test "should validate a subdomain" do
      assert Namor.subdomain?("foo")
      assert Namor.subdomain?("foo-bar")
    end

    test "should invalidate a subdomain" do
      refute Namor.subdomain?("-foo-bar")
      refute Namor.subdomain?("foo-bar-")
      refute Namor.subdomain?("foo$bar")
      refute Namor.subdomain?("$foobar")
      refute Namor.subdomain?("foobar!")
      refute Namor.subdomain?("foo bar")
      assert_raise FunctionClauseError, fn -> refute Namor.subdomain?(1) end
    end

    test "should invalidate a long subdomain" do
      assert String.duplicate("a", 63) |> Namor.subdomain?()
      refute String.duplicate("a", 64) |> Namor.subdomain?()
    end
  end
end
