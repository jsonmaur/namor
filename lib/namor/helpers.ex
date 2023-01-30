defmodule Namor.Helpers do
  @moduledoc """
  Supporting functions for dictionaries and name generation.
  """

  @doc """
  Reads word lists from a base folder and returns a parsed dictionary map.

  A dictionary folder is expected to be a directory containing three files:
  `adjectives.txt`, `nouns.txt`, and `verbs.txt`. Each file should
  have one word per line with no duplicate words.

  If the dictionary name is set to a string, it will only attempt
  to read the one file and return a single list instead of a map.
  Raises a `File.Error` exception if any of the dictionary files
  are not found.

      ┌── reserved.txt
      ├── foobar/
      │ ┌── adjectives.txt
      │ ├── nouns.txt
      │ └── verbs.txt

      iex> Namor.Helpers.get_dict("reserved.txt")
      ["foo", "bar"]

      iex> Namor.Helpers.get_dict(:foobar)
      %{adjectives: ["foo"], nouns: ["bar"], verbs: ["baz"]}

  If not provided, `base_path` will fallback to Namor's internal dictionary
  path.
  """
  @spec get_dict!(binary | atom, binary) :: Namor.Dictionary.t() | [binary]

  def get_dict!(name, base_path \\ nil)

  def get_dict!(name, base_path) when is_binary(name) do
    do_get_dict!(name, base_path)
  end

  def get_dict!(name, base_path) when is_atom(name) do
    Enum.reduce([:adjectives, :nouns, :verbs], %Namor.Dictionary{}, fn type, acc ->
      filename = Atom.to_string(name) |> Path.join("#{type}.txt")
      Map.put(acc, type, do_get_dict!(filename, base_path))
    end)
  end

  defp do_get_dict!(filename, base_path) do
    base_path = base_path || Path.expand("../../dict", __DIR__)

    base_path
    |> Path.join(filename)
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  @doc """
  Returns a word pattern for adjectives, nouns, and verbs in the
  proper order.

  Only supports patterns with a size up to 4.

      iex> Namor.Helpers.get_pattern(4)
      [:adjectives, :nouns, :nouns, :verbs]
  """
  @spec get_pattern(integer) :: [atom]

  def get_pattern(size) when is_integer(size) and size > 0 and size < 5 do
    case size do
      1 -> Enum.random([[:adjectives], [:nouns], [:verbs]])
      2 -> Enum.random([[:adjectives, :nouns], [:nouns, :verbs]])
      3 -> [:adjectives, :nouns, :verbs]
      4 -> [:adjectives, :nouns, :nouns, :verbs]
    end
  end

  @doc """
  Generates a random salt from a character list that can be appended
  to a name for uniqueness.
  """
  @spec get_salt(integer, charlist) :: [binary]

  def get_salt(size, chars) when is_integer(size) and size > 0 do
    for _ <- 1..size, into: "", do: <<Enum.random(chars)>>
  end
end
