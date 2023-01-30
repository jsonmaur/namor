defmodule Namor.Dictionary do
  defstruct [:adjectives, :nouns, :verbs]

  @type t :: %__MODULE__{
          adjectives: [binary],
          nouns: [binary],
          verbs: [binary]
        }
end
