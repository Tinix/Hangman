defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.random_word)
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    }
  end

  @spec make_move(t, String.t) :: {t, Type.tally}
  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  defp accept_guess(game, _guess, _already_guessed = true) do
    %{ game | game_state: :already_used }
  end

  defp accept_guess(game, guess, _already_guessed) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won()
    %{ game | game_state: new_state, turns_left: game.turns_left - 1 }
  end


  defp score_guess(game, _bad_guess) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: game.letters |> reveal_guessed( game.used),
      used: game.used
    }
  end

  defp return_with_tally(game) do
    { game, tally(game) }
  end

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp maybe_reveal(true , letter), do: letter
  defp maybe_reveal(_ , _letter), do: "_
end

