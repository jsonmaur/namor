# Namor

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/jsonmaur/namor.ex/test?label=test&style=plastic)
![Hex.pm](https://img.shields.io/hexpm/v/namor?style=plastic)

Namor is a name generator for Elixir that creates random, url-friendly names. This comes in handy if you need to generate unique subdomains like many PaaS/SaaS providers do, or unique names for anything else.

* ⚡️ Compile-time dictionary loading
* 🔒 Subdomain validation with reserved names
* 📚 Custom dictionaries and reserved word lists
* 🏋️ Hilarious alternate dictionaries
* ✅ 100% test coverage

[Browse the documentation](https://hexdocs.pm/namor) or [see it in action](https://namor.jsonmaur.com).

> _Please Note: Generated names are not always guaranteed to be unique. To reduce the chances of collision, you can increase the length of the trailing number ([see here for collision stats](#collision)). Always be sure to check your database before assuming a generated value is unique._

## Getting Started

```elixir
def deps do
  [
    {:namor, "~> 1.0"}
  ]
end
```

```elixir
iex> require Namor

iex> Namor.generate()
{:ok, "sandwich-invent"}

iex> Namor.generate(salt: 5)
{:ok, "sandwich-invent-s86uo"}

iex> Namor.generate(words: 3, dictionary: :manly)
{:ok, "savage-whiskey-stain"}
```

```elixir
defmodule MyApp.Subdomains do
  use Namor

  @salt_length 5

  def get_new_subdomain(nil), do: Namor.generate(salt: @salt_length)

  def get_new_subdomain(name) do
    with false <- Namor.reserved?(name),
         subdomain <- Namor.with_salt(name, @salt_length),
         true <- Namor.subdomain?(subdomain) do
      {:ok, subdomain}
    else
      _ -> {:error, :invalid_subdomain}
    end
  end
end
```

<a name="collision"></a>

## Collision Stats

The following stats give you the total number of permutations based on the word count (without a salt), and can help you make a decision on how long to make your salt. This data is based on the number of words we currently have in our [dictionary files](https://github.com/jsonmaur/namor.ex/tree/master/dict).

##### `:default` dictionary

- 1-word combinations: 7,948
- 2-word combinations: 11,386,875
- 3-word combinations: 12,382,548,750
- 4-word combinations: 23,217,278,906,250

##### `:manly` dictionary

- 1-word combinations: 735
- 2-word combinations: 127,400
- 3-word combinations: 14,138,880
- 4-word combinations: 3,958,886,400

## Custom Dictionaries

In order for our dictionary files to be loaded into your application during compilation, [`generate/1`](https://hexdocs.pm/namor/Namor.html#generate/1) and [`reserved?/1`](https://hexdocs.pm/namor/Namor.html#reserved?/1) are defined as a macros. This means they can only be used after calling `use Namor` or `require Namor`, which should be done during compilation (and not inside a function). If you want to use your own dictionary, consider calling [`Namor.Helpers.get_dict!/2`](https://hexdocs.pm/namor/Namor.Helpers.html#get_dict!/2) in a place that executes during compilation and **not** runtime. For example:

```
┌ dictionaries/
│ ┌── foobar/
│ │ ┌── adjectives.txt
│ │ ├── nouns.txt
│ │ └── verbs.txt
│ └── reserved.txt
│ foobar.ex
```

```elixir
defmodule MyApp.Foobar do
  @base_path Path.expand("./dictionaries", __DIR__)

  @reserved Namor.Helpers.get_dict!("reserved.txt", @base_path)
  @dictionary Namor.Helpers.get_dict!(:foobar, @base_path)

  defp reserved, do: @reserved
  defp dictionary, do: @dictionary

  def foobar() do
    with {:ok, name} <- Namor.generate([words: 2], dictionary()),
         true <- Namor.subdomain?(name),
         false <- !Namor.reserved?(name, reserved()) do
      # Do something
    end
  end
end
```

## License

[MIT](LICENSE) © [Jason Maurer](https://jsonmaur.com)
