defmodule T2ServerQuery.MixProject do
  use Mix.Project

  def project do
    [
      app: :t2_server_query,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "T2ServerQuery",
      description: "Query any Tribes 2 server and retrieve the current map, players, team scores and more!",
      source_url: "https://github.com/amineo/t2_server_query_elixir",
      homepage_url: "https://github.com/amineo/t2_server_query_elixir",
      docs: [
        main:  "T2ServerQuery",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
