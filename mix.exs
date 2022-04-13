defmodule T2ServerQuery.MixProject do
  use Mix.Project

  def project do
    [
      app: :t2_server_query,
      version: "0.1.2",
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
      ],
      package: package()
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
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      # Code quality, style and linting
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/amineo/t2_server_query_elixir"}
    ]
  end

end
