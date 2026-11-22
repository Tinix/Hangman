defmodule HangmanTest do
  use ExUnit.Case

  alias Hangman.Impl.Game

  doctest Hangman

  defp game_with_word(word) do
    game = Hangman.new_game()
    :sys.replace_state(game, fn _ -> Game.new_game(word) end)
    game
  end

  test "a new game has a hidden word and seven turns" do
    tally = Hangman.tally(Hangman.new_game())

    assert %{game_state: :initializing, turns_left: 7, used: []} = tally
    assert tally.letters != []
    assert Enum.all?(tally.letters, &(&1 == "_"))
  end

  test "make_move returns the updated tally" do
    game = game_with_word("cab")

    assert Hangman.make_move(game, "a") ==
             %{game_state: :good_guess, turns_left: 7, letters: ["_", "a", "_"], used: ["a"]}
  end

  test "moves are remembered between calls" do
    game = game_with_word("cab")
    tally = Hangman.make_move(game, "x")

    assert Hangman.tally(game) == tally
    assert %{game_state: :already_used, turns_left: 6} = Hangman.make_move(game, "x")
  end

  test "games do not share state" do
    first = game_with_word("cab")
    second = game_with_word("dog")
    Hangman.make_move(first, "a")

    assert %{used: [], game_state: :initializing} = Hangman.tally(second)
  end

  test "a game can be won through the public API" do
    game = game_with_word("cab")
    Hangman.make_move(game, "c")
    Hangman.make_move(game, "a")

    assert %{game_state: :won, letters: ["c", "a", "b"]} = Hangman.make_move(game, "b")
  end

  test "a lost game reveals the word, also on later calls" do
    game = game_with_word("cab")
    for guess <- ~w(d e f g h i), do: Hangman.make_move(game, guess)

    lost = Hangman.make_move(game, "j")

    assert %{game_state: :lost, turns_left: 0, letters: ["c", "a", "b"]} = lost
    assert Hangman.make_move(game, "a") == lost
    assert Hangman.tally(game) == lost
  end
end
