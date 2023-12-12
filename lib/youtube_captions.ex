defmodule YoutubeCaptions do
  @moduledoc """
  Youtube captions downloader. Exposes a single function `get_subtitles/3`.

  Fetching is done using library Req. You can pass additional options to `Req.get/2` as 3rd argument.

  ## Examples

      iex> YoutubeCaptions.get_subtitles("JvBT4XBdoUE", "en")
      {:ok,
      [
        %{start: 0.99, text: "[Music]", duration: 6.87},
        %{start: 14.42, text: "thank you so hello everyone and thank", duration: 3.66},
        %{start: 16.67, text: "you for joining me in this talk where", duration: 3.93},
        %{start: 18.08, text: "we're going to explore the legacy of Joe", duration: 3.99},
        %{start: 20.6, text: "Armstrong the principal inventor of", duration: 4.74},
        %{start: 22.07, text: "Erlang who unfortunately recently passed", duration: 5.82},
        %{start: 25.34, text: "away and so Joe sadly will not be with", duration: 3.18},
        %{start: 27.89, text: "us anymore", duration: 2.88},
        ...
      ]}

  """

  @captions_regex ~r/"captionTracks":(?<data>\[.*?\])/

  @type video_id() :: String.t()
  @type lang() :: String.t()
  @type caption() :: %{start: float(), duration: float(), text: String.t()}
  @type req_options() :: keyword()

  @doc """
  Downloads subtitles of YouTube video. You have to specify `video_id` and optionally language. Defaults to `en`.

  Fetching is done using library Req. If you want, you can pass additional params to `Req.get/2` using 3rd argument.

  ## Examples

      iex> YoutubeCaptions.get_subtitles("JvBT4XBdoUE", "en")
      {:ok,
      [
        %{start: 0.99, text: "[Music]", duration: 6.87},
        %{start: 14.42, text: "thank you so hello everyone and thank", duration: 3.66},
        ...
      ]}

      iex> YoutubeCaptions.get_subtitles("JvBT4XBdoUE", "de")
      {:error, "Unable to find transcript for language de"}

      iex> YoutubeCaptions.get_subtitles("invalid", "en")
      {:error, "Could not find captions for video"}

  """
  @spec get_subtitles(video_id(), lang(), req_options()) ::
          {:ok, [caption()]} | {:error, String.t()}
  def get_subtitles(video_id, lang \\ "en", req_options \\ []) do
    with {:ok, data} <- fetch_youtube_data(video_id, req_options),
         {:ok, caption_tracks} <- parse_caption_tracks(data),
         {:ok, transcript_url} <- find_transcript_url(caption_tracks, lang),
         {:ok, transcript_data} <- fetch_transcript(transcript_url, req_options) do
      {:ok, process_transcript(transcript_data)}
    end
  end

  defp fetch_youtube_data(video_id, req_options) do
    url = "https://www.youtube.com/watch?v=#{video_id}"

    case Req.get(url, req_options) do
      {:ok, %{body: body}} -> {:ok, body}
      {:error, _reason} -> {:error, "Failed to fetch YouTube video #{url}"}
    end
  end

  defp parse_caption_tracks(data) do
    case Regex.named_captures(@captions_regex, data) do
      %{"data" => data} -> {:ok, Jason.decode!(data)}
      _ -> {:error, "Could not find captions for video"}
    end
  end

  defp find_transcript_url(caption_tracks, lang) do
    case Enum.find(caption_tracks, &Regex.match?(~r".#{lang}", &1["vssId"])) do
      nil ->
        {:error, "Unable to find transcript for language #{lang}"}

      %{"baseUrl" => base_url} ->
        {:ok, base_url}

      _data ->
        {:error, "Unable to find transcript URL for language #{lang}"}
    end
  end

  defp fetch_transcript(base_url, req_options) do
    case Req.get(base_url, req_options) do
      {:ok, %{body: body}} -> {:ok, body}
      {:error, _reason} -> {:error, "Failed to fetch transcript"}
    end
  end

  defp process_transcript(transcript) do
    transcript
    |> String.replace(~r/^<\?xml version="1.0" encoding="utf-8"\?><transcript>/, "")
    |> String.replace("</transcript>", "")
    |> String.split("</text>")
    |> Enum.filter(&(String.trim(&1) != ""))
    |> Enum.map(&process_line/1)
  end

  defp process_line(line) do
    %{"start" => start} = Regex.named_captures(~r/start="(?<start>[\d.]+)"/, line)
    %{"dur" => dur} = Regex.named_captures(~r/dur="(?<dur>[\d.]+)"/, line)

    text =
      line
      |> String.replace("&amp;", "&")
      |> String.replace(~r/<text.+>/, "")
      |> String.replace(~r"</?[^>]+(>|$)", "")
      |> HtmlEntities.decode()
      |> String.trim()

    %{start: parse_float(start), duration: parse_float(dur), text: text}
  end

  defp parse_float(val) do
    {num, _} = Float.parse(val)
    num
  end
end
