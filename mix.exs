defmodule Namor.MixProject do
  use Mix.Project

  @url "https://github.com/jsonmaur/namor.ex"

  def project do
    [
      app: :namor,
      version: "1.0.0",
      elixir: "~> 1.13",
      deps: deps(),
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      description: "A subdomain-safe name generator",
      source_url: @url,
      homepage_url: "#{@url}#readme",
      package: [
        name: "Namor",
        licenses: ["MIT"],
        links: %{"GitHub" => @url, "Demo" => "https://namor.jsonmaur.com"},
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
