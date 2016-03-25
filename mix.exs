defmodule AmqpOne.Mixfile do
  use Mix.Project
  defp aliases do
    [
      "do_release": ["release.clean", "compile", "release"],
      "docs": ["docs", &copy_images/1]
    ]
  end

  def project do
    [app: :ampq_one,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: Coverex.Task],
     aliases: aliases,
      docs: [extras: ["README.md"], main: "README"],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ranch, :sasl],
     mod: {AmqpOne, []}]
  end
  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # copy the images to the docs directory
  defp copy_images(_args_list) do
    File.ls!
    |> Stream.filter(&(".png" == Path.extname(&1)))
    |> Enum.each(&(File.cp &1, "doc/" <> &1))
  end

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
    [
      {:ranch, "~> 1.2"},
      {:dialyze, "~> 0.2.0", only: [:dev, :test]},
      {:ex_doc, "~>0.8", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.3.0", only: :dev},
      {:coverex, "~> 1.4.8", only: :test}
    ]
  end
end
