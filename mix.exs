defmodule Transponder.MixProject do
  use Mix.Project

  def project do
    [
      app: :transponder,
      version: "0.1.4",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: "DSL for declarative Phoenix controllers",
      package: [
        maintainers: ["Joshua Nussbaum"],
        licenses: ["MIT"],
        links: %{github: "https://github.com/joshnuss/transponder"}
      ],
      deps: deps()
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
      {:phoenix, "~> 1.5"},
      {:phoenix_html, "~> 2.14"},
      {:ecto, "~> 3.4"},
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
