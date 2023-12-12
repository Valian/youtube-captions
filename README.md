# YoutubeCaptions
[![Module Version](https://img.shields.io/hexpm/v/youtube_captions.svg)](https://hex.pm/packages/youtube_captions)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/youtube_captions/)
[![Total Download](https://img.shields.io/hexpm/dt/youtube_captions.svg)](https://hex.pm/packages/youtube_captions)
[![License](https://img.shields.io/hexpm/l/youtube_captions.svg)](https://github.com/Valian/youtube_captions/blob/main/LICENSE.md)

An elixir library for fetching Youtube Captions without API key. Uses [Req](https://github.com/wojtekmach/req) under the hood.

## Installation

The package can be installed by adding `youtube_captions` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:youtube_captions, "~> 0.1.0"}
  ]
end
```

And run `mix deps.get`.

## Usage

First find video identifier. You can find it in the YouTube URL `?v=VIDEO_ID`.

Then you can download captions by calling `YoutubeCaptions.get_subtitles(video_id, language)`. Language is optional and defaults to `en`. 

If successfull, you'll get list of subtitles in format `%{start: float(), duration: float(), text: String.t()}`

### Examples

```elixir
YoutubeCaptions.get_subtitles("JvBT4XBdoUE", "en")

#=> {:ok,
#=>   [
#=>     %{start: 0.99, text: "[Music]", duration: 6.87},
#=>     %{start: 14.42, text: "thank you so hello everyone and thank", duration: 3.66},
#=>     ...
#=>   ]}

# You can customize Req options by passing third parameter
YoutubeCaptions.get_subtitles("JvBT4XBdoUE", "en", receive_timeout: 10_000)

```

## Credits

Heavily inspired by [youtube-captions-scraper](https://github.com/algolia/youtube-captions-scraper).

## License

    Copyright © 2023-present Jakub Skałecki

    This work is free. You can redistribute it and/or modify it under the
    terms of the MIT License. See the LICENSE.md file for more details.