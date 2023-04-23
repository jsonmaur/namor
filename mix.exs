defmodule Namor.MixProject do
  use Mix.Project

  @url "https://github.com/jsonmaur/namor.ex"

  def project do
    [
      app: :namor,
      name: "Namor",
      version: "1.0.2",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      source_url: @url,
      homepage_url: "#{@url}#readme",
      description: "A subdomain-safe name generator",
      authors: ["Jason Maurer"],
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => @url, "Demo" => "https://namor.jsonmaur.com"},
        files: ~w(dict lib .formatter.exs mix.exs LICENSE README.md)
      ],
      docs: [
        main: "readme",
        extras: ["README.md"]
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
