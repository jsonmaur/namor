defmodule Namor.Helpers do
  @moduledoc """
  Documentation for `Namor.Helpers`.
  """

  @doc """
  Documentation for `Namor.Helpers.get_dict`.
  """
  def get_dict(:reserved, base_dir) do
    do_get_dict("reserved.txt", base_dir)
  end

  def get_dict(name, base_dir) do
    for type <- [:adjective, :noun, :verb], into: %{} do
      filename = Atom.to_string(name) |> Path.join("#{type}s.txt")
      {type, do_get_dict(filename, base_dir)}
    end
  end

  defp do_get_dict(filename, base_dir) do
    base_dir
    |> Path.join(filename)
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  @doc """
  Documentation for `Namor.Helpers.get_pattern`.
  """
  def get_pattern(size) when is_integer(size) and size > 0 and size < 5 do
    case size do
      1 -> [:noun]
      2 -> Enum.random([[:adjective, :noun], [:noun, :verb]])
      3 -> [:adjective, :noun, :verb]
      4 -> [:adjective, :noun, :noun, :verb]
    end
  end

  @doc """
  Documentation for `Namor.Helpers.get_salt`.
  """
  def get_salt(size, chars)
      when is_integer(size) and size > 0 do
    for _ <- 1..size, into: "", do: <<Enum.random(chars)>>
  end
end
