defmodule CodeSamples.Mixfile do
  use Mix.Project

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def project do
    [
      app: :insta_iphoto,
      version: "0.1.0",
      elixir: "~> 1.12",
      deps: deps()
    ]
  end

  defp deps do
     [
       {:jason, "~> 1.2"},
     ]
  end
end
