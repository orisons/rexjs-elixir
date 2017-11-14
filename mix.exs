defmodule Orisons.RexJS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rexjs,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      dialyzer: [plt_add_deps: :apps_direct],

      name: "RexJS",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/orisons/rexjs-elixir",
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
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:cowboy, "~> 1.1"},
      {:poison, "~> 3.1"}
    ]
  end

  defp description() do
    "Library for reactivity between elixir data with front-end through javascript websockets."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "rexjs",
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Krystian Drożdżyński"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/orisons/rexjs-elixir", "Website" => "https://orisons.io"}
    ]
  end
end
