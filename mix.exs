defmodule Namor.MixProject do
  use Mix.Project

  @url "https://github.com/jsonmaur/namor"

  def project do
    [
      app: :namor,
      name: "Namor",
      version: "1.0.4",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      source_url: @url,
      homepage_url: "#{@url}#readme",
      description: "A subdomain-safe name generator",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => @url},
        files: ~w(dict lib .formatter.exs CHANGELOG.md LICENSE mix.exs README.md)
      ],
      docs: [
        main: "readme",
        extras: ["README.md"],
        authors: ["Jason Maurer"]
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

  defp aliases do
    [
      test: [
        "format --check-formatted",
        "deps.unlock --check-unused",
        "compile --warnings-as-errors",
        "test"
      ]
    ]
  end
end
