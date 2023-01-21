defmodule Namor do
  @moduledoc """
  A subdomain-safe name generator.
  """

  defmacro __using__(_) do
    dict_dir = Path.expand("../dict", __DIR__)

    quote do
      @namor_reserved Namor.Helpers.get_dict(:reserved, unquote(dict_dir))
      @namor_dictionary %{
        default: Namor.Helpers.get_dict(:default, unquote(dict_dir)),
        manly: Namor.Helpers.get_dict(:manly, unquote(dict_dir))
      }
    end
  end

  @doc """
  Documentation for `Namor.generate`.
  """
  defmacro generate(opts \\ []) do
    words = Keyword.get(opts, :words, 2)
    salt = Keyword.get(opts, :salt, 0)
    salt_type = Keyword.get(opts, :salt_type, :mixed)
    separator = Keyword.get(opts, :separator, "-")
    dictionary = Keyword.get(opts, :dictionary, :default)

    salt_chars =
      case salt_type do
        :digits -> '0123456789'
        :letters -> 'abcdefghijklmnopqrstuvwxyz'
        :mixed -> 'abcdefghijklmnopqrstuvwxyz0123456789'
      end

    quote do
      dict = Map.get(@namor_dictionary, unquote(dictionary))

      name =
        Namor.Helpers.get_pattern(unquote(words))
        |> Enum.map_join(unquote(separator), &(dict |> Map.get(&1) |> Enum.random()))

      name =
        if unquote(salt) > 0,
          do:
            name <>
              unquote(separator) <> Namor.Helpers.get_salt(unquote(salt), unquote(salt_chars)),
          else: name

      {:ok, name}
    end
  end

  @doc """
  Documentation for `Namor.subdomain?`.
  """
  defmacro subdomain?(value, opts \\ []) do
    reserved = Keyword.get(opts, :reserved, true)

    valid_subdomain_pattern = Macro.escape(~r/^[\w](?:[\w-]{0,61}[\w])?$/)
    strip_nonalphanumeric_pattern = Macro.escape(~r/[^a-zA-Z0-9]/)

    quote do
      valid = Regex.match?(unquote(valid_subdomain_pattern), unquote(value))

      if unquote(reserved) do
        value = Regex.replace(unquote(strip_nonalphanumeric_pattern), unquote(value), "")
        valid && !Enum.member?(@namor_reserved, value)
      else
        valid
      end
    end
  end
end
