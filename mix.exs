defmodule Namor.MixProject do
  use Mix.Project

  @url "https://github.com/jsonmaur/namor"

  def project do
    [
      app: :namor,
      version: "1.0.0",
      elixir: "~> 1.13",
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      name: "Namor",
      description: "A domain-safe name generator",
      source_url: @url,
      homepage_url: "#{@url}#readme",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => @url},
        files: ~w(dict lib LICENSE mix.exs README.md)
      ],
      docs: [
        extras: ["LICENSE", "README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
