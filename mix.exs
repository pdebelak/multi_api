defmodule MultiApi.Mixfile do
  use Mix.Project

  def project do
    [app: :multi_api,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {MultiApi, []},
      applications: applications(Mix.env)
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :cowboy, :plug, :httpotion]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:poison, "~> 2.0"},
     {:httpotion, "~> 3.0.0"},
     {:bypass, "~> 0.1", only: :test},
     {:remix, "~> 0.0.1", only: :dev},
     {:plug, "~> 1.0"}]
  end
end
