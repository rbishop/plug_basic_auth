defmodule PlugBasicAuth.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_basic_auth,
     version: "0.0.1",
     elixir: "~> 0.15.0",
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:plug, "~> 0.5.0"}]
  end
end
