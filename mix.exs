defmodule AuthZuma.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth_zuma,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {AuthZuma.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1", override: true},
      {:tesla, "~> 1.0"},
      {:joken_jwks, github: "victorolinasc/joken_jwks"}
    ]
  end
end
