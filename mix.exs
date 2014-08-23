defmodule PlugBasicAuth.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_basic_auth,
     version: "0.1.1",
     elixir: "~> 0.15.0",
     deps: deps,
     package: package,
     name: "Plug Basic Auth",
     source_url: "https://github.com/rbishop/plug_basic_auth",
     homepage_url: "https://github.com/rbishop/plug_basic_auth",
     description: "A Plug for using HTTP Basic Authentication in Plug applications",
     docs: [readme: true, main: "README"]]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0", only: [:test, :dev]},
     {:plug, github: "elixir-lang/plug"},
     {:ex_doc, github: "elixir-lang/ex_doc", only: [:docs]}]
  end

  defp package do
    %{licenses: ["Apache 2"],
      contributors: ["Richard Bishop"],
      links: %{"Github" => "https://github.com/rbishop/plug_basic_auth"}}
  end
end
