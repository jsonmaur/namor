defmodule NamorTest do
  use ExUnit.Case
  use Namor

  @default_nouns Path.expand("../dict/default/nouns.txt", __DIR__)
  @manly_nouns Path.expand("../dict/manly/nouns.txt", __DIR__)

  doctest Namor

  test "should be able to get raw dictionary data" do
    assert Enum.count(@namor_reserved) > 0
    assert Map.has_key?(@namor_dictionary, :default)
    assert Map.has_key?(@namor_dictionary, :manly)
  end

  describe "generate/1" do
    test "should generate a name" do
      assert {:ok, name} = Namor.generate()
      assert String.split(name, "-") |> Enum.count() == 2
    end

    test "should generate a name with 1 word" do
      assert {:ok, name} = Namor.generate(words: 1)
      assert name =~ ~r/^[a-z0-9]*$/
      refute name =~ "-"
      assert File.read!(@default_nouns) =~ name
    end

    test "should generate a name with 3 words" do
      assert {:ok, name} = Namor.generate(words: 3)
      assert String.split(name, "-") |> Enum.count() == 3
    end

    test "should generate a name with 4 words" do
      assert {:ok, name} = Namor.generate(words: 4)
      assert String.split(name, "-") |> Enum.count() == 4
    end

    test "should max out at 4 words" do
      assert_raise FunctionClauseError, fn -> Namor.generate(words: 5) end
    end

    test "should generate a name with a mixed salt" do
      assert {:ok, name} = Namor.generate(salt: 10)
      assert split = String.split(name, "-")
      assert split |> Enum.take(-1) |> Enum.at(0) =~ ~r/^[a-z0-9]{10}$/
      assert Enum.count(split) == 3
    end

    test "should generate a name with a numeric salt" do
      assert {:ok, name} = Namor.generate(salt: 10, salt_type: :digits)
      assert name |> String.split("-") |> Enum.take(-1) |> Enum.at(0) =~ ~r/^[0-9]{10}$/
    end

    test "should generate a name with a alpha salt" do
      assert {:ok, name} = Namor.generate(salt: 10, salt_type: :letters)
      assert name |> String.split("-") |> Enum.take(-1) |> Enum.at(0) =~ ~r/^[a-z]{10}$/
    end

    test "should generate a name with a custom separator" do
      assert {:ok, name} = Namor.generate(separator: "_", salt: 5)
      assert String.split(name, "_") |> Enum.count() == 3
    end

    test "should generate a name with an alternate dictionary" do
      assert {:ok, name} = Namor.generate(words: 1, dictionary: :manly)
      assert File.read!(@manly_nouns) =~ name
    end
  end

  describe "subdomain?/1" do
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

    test "should invalidate a reserved subdomain" do
      refute Namor.subdomain?("login")
      refute Namor.subdomain?("log in")
      refute Namor.subdomain?("log-in")
      refute Namor.subdomain?("log--in")
      assert Namor.subdomain?("login", reserved: false)
      assert Namor.subdomain?("log-in", reserved: false)
    end

    test "should invalidate a long subdomain" do
      assert String.duplicate("a", 63) |> Namor.subdomain?()
      refute String.duplicate("a", 64) |> Namor.subdomain?()
    end
  end
end
