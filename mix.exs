defmodule Noegle.Mixfile do
  use Mix.Project

  def project do
    [app: :noegle,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     deps: deps(),
     name: "Noegle",
     source_url: "https://github.com/jespr/noegle",
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :comeonin, :ecto, :postgrex]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:comeonin, "~> 3.0"},
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0", only: :test},
    ]
  end

  defp description do
    """
    The goal is to make password authentication a little easier when building a new Elixir/Phoenix application.
    """
  end
end
