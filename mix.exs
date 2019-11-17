defmodule Companion.MixProject do
  use Mix.Project

  def project do
    [
      app: :companion_ex,
      version: "0.1.3",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      source_url: "https://github.com/kuwoyuki/companion-elixir"
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
      {:httpoison, "~> 1.6"},
      {:elixir_uuid, "~> 1.2"},
      {:x509, "~> 0.7.0"},
      {:poison, "~> 4.0"},
      {:plug_crypto, "~> 1.0"},
      {:floki, "~> 0.23"}
    ]
  end

  defp description() do
    "Library for FFXIV Companion API."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kuwoyuki/companion-elixir"}
    ]
  end
end
