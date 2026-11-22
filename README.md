# Hangman Game in Elixir

The classic word-guessing game, played in the terminal. The computer picks an
English word and you guess it one letter at a time, before you run out of turns.

## Requirements

| Tool       | Minimum version |
|------------|-----------------|
| Elixir     | 1.16            |
| Erlang/OTP | 26              |

Tested with these combinations:

| Elixir | Erlang/OTP |
|--------|------------|
| 1.16.2 | 26.2.5     |
| 1.18.4 | 26.2.5     |
| 1.20.5 | 29.1.2     |

Check what you have installed:

```sh
elixir --version
```

If you need to install them, follow the
[official installation guide](https://elixir-lang.org/install.html).
The project has no third-party dependencies.

## Quick start

```sh
git clone https://github.com/Tinix/hangman.git
cd hangman/text_client
mix deps.get
mix run -e "TextClient.start()"
```

You can also play from an interactive shell:

```sh
cd text_client    # from the repository root
iex -S mix
```

```elixir
iex> TextClient.start()
```

## How to play

1. Type one letter from `a` to `z` and press Enter. Uppercase works too.
2. A wrong letter costs one of your **7 turns**.
3. A correct or repeated letter costs nothing.
4. Anything that is not a single letter is rejected and costs nothing.
5. You win by revealing every letter. If you run out of turns, the word is shown.

To quit a game:

- started with `mix run`: press `Ctrl+D`, or `Ctrl+C` twice
- started inside `iex`: press `Ctrl+C` twice (`Ctrl+D` does not work there)

Example, for the word `cab`:

```text
Welcome! I'm thinking of a word with 3 letters
Word so far: _ _ _   turns left: 7   used so far:
Next letter: a
Good guess!
Word so far: _ a _   turns left: 7   used so far: a
Next letter: x
Sorry, that letter's not in the word
Word so far: _ a _   turns left: 6   used so far: a,x
Next letter: c
Good guess!
Word so far: c a _   turns left: 6   used so far: a,c,x
Next letter: b
Congratulations. You won! The word was cab
```

## Project structure

The repository contains three separate Mix projects. There is no `mix.exs` at
the root, so always run `mix` inside one of these directories:

| Directory                     | Purpose                              | Depends on   |
|-------------------------------|--------------------------------------|--------------|
| [`dictionary`](dictionary)    | Supplies random words                | -            |
| [`hangman`](hangman)          | Game rules, one process per game     | `dictionary` |
| [`text_client`](text_client)  | Terminal interface                   | `hangman`    |

```text
text_client  -->  hangman  -->  dictionary
 (terminal)      (GenServer)      (Agent)
```

Each project keeps its logic in `lib/impl`. Where processes are needed, they
live in `lib/runtime`.

## Running the tests

From the repository root, run all the tests:

```sh
for app in dictionary hangman text_client; do
  (cd "$app" && mix deps.get && mix test) || break
done
```

Or test a single project:

```sh
cd hangman
mix deps.get
mix test
```

To run the same checks as CI, inside a project:

```sh
mix deps.get
MIX_ENV=test mix compile --warnings-as-errors
mix test --warnings-as-errors
```

## Using the game from Elixir

Inside `hangman`, start `iex -S mix`:

```elixir
game = Hangman.new_game()
Hangman.tally(game)
Hangman.make_move(game, "e")
```

Both `tally/1` and `make_move/2` return a map with these keys:

| Key           | Content                                                     |
|---------------|-------------------------------------------------------------|
| `:game_state` | One of the states listed below                              |
| `:turns_left` | Turns remaining                                             |
| `:letters`    | Letters of the word, with `"_"` for the ones still hidden   |
| `:used`       | Sorted list of the letters guessed so far                   |

The states are `:initializing`, `:good_guess`, `:bad_guess`, `:already_used`,
`:won` and `:lost`. When a game is lost, `:letters` contains the whole word.

`make_move/2` expects one lowercase letter. Validating what the player types is
the client's job.

## Changing the words

Edit [`dictionary/assets/words.txt`](dictionary/assets/words.txt): one word per
line, lowercase `a` to `z`, no duplicates. The list is read at compile time and
Mix recompiles it when the file changes. Run the `dictionary` tests to check it.

## Contributing

Please read the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE)
