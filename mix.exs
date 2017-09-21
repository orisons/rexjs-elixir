defmodule Orisons.RexJS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rexjs,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :apps_direct],

      name: "RexJS",
      docs: [main: "RexJS", # The main page in the docs
              # logo: "path/to/logo.png",
              extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Orisons.RexJS, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:cowboy, "~> 1.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
