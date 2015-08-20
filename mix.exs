defmodule PlugBasicAuth.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_basic_auth,
     version: "1.0.0",
     elixir: "~> 1.0",
     deps: deps,
     package: package,
     name: "Plug Basic Auth",
     source_url: "https://github.com/rbishop/plug_basic_auth",
     homepage_url: "https://github.com/rbishop/plug_basic_auth",
     description: "A Plug for using HTTP Basic Authentication in Plug applications",
     docs: [readme: "README.md", main: "README"]]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 0.13 or ~> 1.0"},
     {:ex_doc, "~> 0.7", only: :dev}]
  end

  defp package do
    %{licenses: ["Apache 2"],
      contributors: ["Richard Bishop"],
      links: %{"Github" => "https://github.com/rbishop/plug_basic_auth"}}
  end
end
