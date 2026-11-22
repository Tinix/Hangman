# Dictionary

Supplies random English words to the [Hangman game](../README.md). The word
server starts automatically with the application.

Requires Elixir 1.16+ and Erlang/OTP 26+.

```sh
cd dictionary    # from the repository root
mix test
iex -S mix
```

```elixir
iex> Dictionary.random_word()
```

The words live in [`assets/words.txt`](assets/words.txt).
