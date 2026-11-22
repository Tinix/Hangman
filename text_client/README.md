# TextClient

The terminal interface of the [Hangman game](../README.md).

Requires Elixir 1.16+ and Erlang/OTP 26+.

```sh
cd text_client    # from the repository root
mix deps.get
mix test
mix run -e "TextClient.start()"
```

Type one letter and press Enter. Press `Ctrl+D` to quit, or `Ctrl+C` twice when
playing inside `iex`.
