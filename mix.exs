defmodule ExJira.Mixfile do
  use Mix.Project

  def project do
    [app: :exjira,
     version: "0.0.2",
     elixir: "~> 1.7",
     deps: deps(),
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :dotenv]]
  end

  defp deps do
    [
      {:oauth, github: "tim/erlang-oauth"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.3", only: [:dev, :test]},
      {:dotenv, "~> 2.0.0"},
      {:ex_doc, "~> 0.19.2"}
    ]
  end

  defp description do
    """
    JIRA client library for Elixir
    """
  end

  defp package do
    [ contributors: ["mattweldon","edwinallenz"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/edwinallenz/exjira"} ]
  end
end
