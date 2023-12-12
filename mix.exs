defmodule YoutubeCaptions.MixProject do
  use Mix.Project

  @source_url "https://github.com/Valian/youtube_captions"
  @version "0.1.0"

  def project do
    [
      app: :youtube_captions,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp package do
    [
      description: "An Elixir library for fetching youtube captions without API key.",
      files: ["lib", "mix.exs", "README*", "LICENSE*", "doc"],
      maintainers: ["Jakub Skałecki"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp deps do
    [
      {:html_entities, "~> 0.5"},
      {:req, "~> 0.3"}
    ]
  end
end
