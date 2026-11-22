# Hangman

The rules of the [Hangman game](../README.md). Each game runs in its own
GenServer, linked to the process that created it.

Requires Elixir 1.16+ and Erlang/OTP 26+.

```sh
cd hangman    # from the repository root
mix deps.get
mix test
iex -S mix
```

```elixir
iex> game = Hangman.new_game()
iex> Hangman.make_move(game, "e")
iex> Hangman.tally(game)
```

See [Using the game from Elixir](../README.md#using-the-game-from-elixir) for
the returned values.
