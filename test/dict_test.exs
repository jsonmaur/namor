defmodule DictTest do
  use ExUnit.Case

  @dict_dir Path.expand("../dict", __DIR__)

  # Only need to check nouns against reserved word list,
  # since those are the only words that will ever be
  # generated on their own.

  test "should be no reserved words in default nouns" do
    assert_no_reserved(:default)
  end

  test "should be no reserved words in manly nouns" do
    assert_no_reserved(:manly)
  end

  defp assert_no_reserved(dict) do
    words = Namor.Helpers.get_dict(dict, @dict_dir).noun
    reserved = Namor.Helpers.get_dict(:reserved, @dict_dir)

    for reserved_word <- reserved do
      if Enum.member?(words, reserved_word),
        do: flunk("\"#{reserved_word}\" is a reserved word, but found it in #{dict}")
    end
  end
end
