defmodule NamorDemo.Params do
  import Ecto.Changeset

  alias __MODULE__

  defstruct [:words, :salt, :salt_type, :separator, :dictionary]

  @types %{
    words: :integer,
    salt: :integer,
    salt_type: {:parameterized, Ecto.Enum, Ecto.Enum.init(values: [:mixed, :letters, :numbers])},
    separator: :string,
    dictionary: {:parameterized, Ecto.Enum, Ecto.Enum.init(values: [:default, :manly])}
  }

  def changeset(%Params{} = params, attrs \\ %{}) do
    {params, @types}
    |> cast(attrs, Map.keys(@types), empty_values: [])
    |> validate_number(:words, greater_than: 0, less_than_or_equal_to: 4)
    |> validate_number(:salt, greater_than_or_equal_to: 0)
    |> validate_length(:separator, min: 0, max: 10)
  end
end
