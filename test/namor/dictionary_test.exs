defmodule DictTest do
  use ExUnit.Case

  alias Namor.Helpers

  @dict_dir Path.expand("../../dict", __DIR__)

  test "should create dictionary struct" do
    assert %{adjectives: nil, nouns: nil, verbs: nil} = %Namor.Dictionary{}
  end

  describe "dict files" do
    test "should be no reserved words in default nouns" do
      assert_no_reserved(:default)
      assert_no_duplicates(:default)
    end

    test "should be no reserved words in manly nouns" do
      assert_no_reserved(:manly)
      assert_no_duplicates(:manly)
    end
  end

  defp assert_no_reserved(name) do
    dict = Helpers.get_dict!(name, @dict_dir)

    for word <- Helpers.get_dict!("reserved.txt", @dict_dir),
        {type, words} <- Map.from_struct(dict) do
      if Enum.member?(words, word) do
        flunk("\"#{word}\" is a reserved word, but found it in #{name}.#{type}")
      end
    end
  end

  defp assert_no_duplicates(name) do
    dict = Helpers.get_dict!(name, @dict_dir)

    for {type, words} <- Map.from_struct(dict) do
      if (duplicated = words -- Enum.uniq(words)) != [] do
        flunk("Found some duplicated words in #{name}.#{type}: #{Enum.join(duplicated, ", ")}")
      end
    end
  end
end
