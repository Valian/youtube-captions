defmodule YoutubeCaptions.MixProject do
  use Mix.Project

  @source_url "https://github.com/Valian/youtube_captions"
  @version "0.1.0"

  def project do
    [
      app: :youtube_captions,
      name: "YoutubeCaptions",
      version: @version,
      elixir: "~> 1.10",
      source_url: @source_url,
      description: "An Elixir library for fetching youtube captions without API key.",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    []
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ],
      source_ref: "v#{@version}",
      source_url: @source_url,
      groups_for_modules: [
        Markdown: [
          ExDoc.Markdown,
          ExDoc.Markdown.Earmark
        ]
      ],
      skip_undefined_reference_warnings_on: [
        "CHANGELOG.md"
      ]
    ]
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
      {:req, "~> 0.3"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
