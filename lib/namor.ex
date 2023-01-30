defmodule Namor do
  @moduledoc """
  A subdomain-safe name generator.
  """

  alias Namor.Helpers

  @type_generate_options quote(
                           do: [
                             words: integer,
                             salt: integer,
                             salt_type: :numbers | :letters | :mixed,
                             separator: binary
                           ]
                         )

  @strip_nonalphanumeric_pattern ~r/[^a-zA-Z0-9]/
  @valid_subdomain_pattern ~r/^[\w](?:[\w-]{0,61}[\w])?$/

  @reserved Namor.Helpers.get_dict!("reserved.txt")
  @dictionaries %{
    default: Namor.Helpers.get_dict!(:default),
    manly: Namor.Helpers.get_dict!(:manly)
  }

  @doc false
  defmacro __using__(_opts) do
    quote do
      # TODO: Allow custom dictionaries to be passed through `opts`
    end
  end

  @doc """
  Get Namor's dictionaries.
  """
  @spec get_dictionaries :: %{binary => Namor.Dictionary.t()}
  def get_dictionaries, do: @dictionaries

  @doc """
  Get Namor's reserved word list.
  """
  @spec get_reserved :: [binary]
  def get_reserved, do: @reserved

  @doc """
  Generates a random name from a Namor dictionary.

  Returns `{:ok, name}` for a successfully generated name, or
  `{:error, reason}` if something goes wrong. See [Custom Dictionaries](README.md#custom-dictionaries)
  for instructions on how to use a custom dictionary.

  ## Options

    * `:words` - Number of words to generate. Must be <=4. Defaults to `2`.
    * `:salt` - Length of the salt to append. Must be >=0. Defaults to `0`.
    * `:salt_type` - Whether the salt should contain numbers, letters, or both. Defaults to `:mixed`.
    * `:separator` - String to use as a separator between words. Defaults to `-`.
    * `:dictionary` - Namor dictionary to use. Defaults to `:default`.

  ## Error Reasons

    * `:dict_not_found` - Could not find the specified dictionary.

  ## Example

      iex> require Namor
      Namor

      iex> Namor.generate(words: 3, dictionary: :manly)
      {:ok, "savage-whiskey-stain"}

  """
  @spec generate([unquote_splicing(@type_generate_options), dictionary: :default | :manly]) ::
          {:ok, binary} | {:error, atom}

  defmacro generate(opts \\ []) when is_list(opts) do
    {dictionary, opts} = Keyword.pop(opts, :dictionary, :default)

    quote do
      case Namor.get_dictionaries() |> Map.get(unquote(dictionary)) do
        nil -> {:error, :dict_not_found}
        dict -> Namor.generate(unquote(opts), dict)
      end
    end
  end

  @doc """
  Generates a random name from a custom dictionary.

  Returns `{:ok, name}` for a successfully generated name. Takes the
  same options as `generate/1` with the exception of `:dictionary`.
  """
  @spec generate(unquote(@type_generate_options), Namor.Dictionary.t()) :: {:ok, binary}

  def generate(opts, %Namor.Dictionary{} = dict) when is_list(opts) do
    words = Keyword.get(opts, :words, 2)
    salt = Keyword.get(opts, :salt, 0)
    salt_type = Keyword.get(opts, :salt_type, :mixed)
    separator = Keyword.get(opts, :separator, "-")

    salt_chars =
      case salt_type do
        :numbers -> '0123456789'
        :letters -> 'abcdefghijklmnopqrstuvwxyz'
        :mixed -> 'abcdefghijklmnopqrstuvwxyz0123456789'
      end

    name =
      Helpers.get_pattern(words)
      |> Enum.map_join(separator, &(Map.get(dict, &1) |> Enum.random()))

    name =
      if salt > 0,
        do: name <> separator <> Helpers.get_salt(salt, salt_chars),
        else: name

    {:ok, name}
  end

  @doc """
  Checks whether a value exists in Namor's list of reserved words.

  See `reserved?/2` for more info. See [Custom Dictionaries](README.md#custom-dictionaries)
  for instructions on how to use a custom reserved word list.
  """
  @spec reserved?(binary) :: boolean

  defmacro reserved?(value) when is_binary(value),
    do: quote(do: Namor.reserved?(unquote(value), Namor.get_reserved()))

  @doc """
  Checks whether a value exists in a provided list of reserved words.

  Before checking, the value is stripped of all special characters.
  So for example, `log-in` will still return true if `["login"]` is
  passed to `reserved`.
  """
  @spec reserved?(binary, [binary]) :: boolean

  def reserved?(value, reserved) when is_binary(value) and is_list(reserved),
    do: Enum.member?(reserved, Regex.replace(@strip_nonalphanumeric_pattern, value, ""))

  @doc """
  Checks whether a given value is a valid subdomain.

  Valid subdomains contain no special characters other than `-`, and
  are 63 characters or less.
  """
  @spec subdomain?(binary) :: boolean

  def subdomain?(value) when is_binary(value),
    do: Regex.match?(@valid_subdomain_pattern, value)
end