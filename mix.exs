defmodule Companion.MixProject do
  use Mix.Project

  def project do
    [
      app: :companion,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {Companion.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:httpoison_retry, git: "https://github.com/everilae/httpoison_retry.git"},
      {:httpoison, "~> 1.6"},
      {:elixir_uuid, "~> 1.2"},
      {:x509, "~> 0.7.0"},
      {:poison, "~> 3.1"},
      {:plug_crypto, "~> 1.0"},
      {:floki, "~> 0.23.0"}
    ]
  end
end
