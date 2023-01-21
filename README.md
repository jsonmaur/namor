# Namor

Namor is a name generator for Elixir that creates random, url-friendly names. This comes in handy if you need to generate unique subdomains like many PaaS providers, or unique names for anything else.

> _Please Note: Generated names are not always guaranteed to be unique. To reduce the chances of collision, you can increase the length of the trailing number ([see here for collision stats](#collision)). Always be sure to check your database before assuming a generated value is unique._

## Getting Started

```elixir
def deps do
  [
    {:namor, "~> 1.0.0"}
  ]
end
```

```elixir
# defaults to two words
Namor.generate()

# generate 3 word names with a 5-character salt 
Namor.generate(words: 3, salt: 5)

# generate names from an alternate dictionary
Namor.generate(dictionary: :manly)
```

[See it in action here](). [Experience manly mode if you're ready for it.]().

<a name="collision"></a>

## Collision Stats

The following stats give you the total number of permutations based on the word count (without a salt), and can help you make a decision on how long to make your salt. This data is based on the number of words we currently have in our [dictionary files](dict).

- 1-word combinations: 1,875
- 2-word combinations: 11,503,125
- 3-word combinations: 12,827,906,250
- 4-word combinations: 24,052,324,218,750

##### Manly Dictionary

- 1-word combinations: 280
- 2-word combinations: 128,520
- 3-word combinations: 14,353,920
- 4-word combinations: 4,019,097,600

### .rawData

Allows access to the raw dictionary data. You probably won't ever use this, but it's there if you need it.

## License

[MIT](license) © [Jason Maurer](https://maur.co)
