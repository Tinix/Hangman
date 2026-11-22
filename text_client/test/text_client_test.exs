defmodule TextClientTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias TextClient.Impl.Player

  doctest TextClient

  defp play(word, input) do
    game = Hangman.new_game()
    :sys.replace_state(game, fn _ -> Hangman.Impl.Game.new_game(word) end)

    capture_io(input, fn ->
      assert Player.interact({game, Hangman.tally(game)}) == :ok
    end)
  end

  test "start welcomes the player" do
    output = capture_io("", fn -> assert TextClient.start() == :ok end)

    assert output =~ ~r/Welcome! I'm thinking of a word with \d+ letters/
  end

  test "a player can win" do
    output = play("cab", "c\na\nb\n")

    assert output =~ "Good guess!"
    assert output =~ "Congratulations. You won! The word was cab"
  end

  test "a player can lose and is told the word" do
    output = play("cab", "d\ne\nf\ng\nh\ni\nj\n")

    assert output =~ "Sorry, that letter's not in the word"
    assert output =~ "Sorry, you lost... the word was cab"
  end

  test "a repeated letter is reported without costing a turn" do
    output = play("cab", "x\nx\n")

    assert output =~ "You already used that letter"
    refute output =~ "turns left: 5"
  end

  test "uppercase letters and surrounding spaces are accepted" do
    assert play("cab", " C \nA\n\tB\n") =~ "You won!"
  end

  for {name, input} <- [empty: "", spaces: "   ", several: "ab", digit: "7", symbol: "!", accent: "á"] do
    test "invalid input (#{name}) asks again without costing a turn" do
      output = play("cab", unquote(input) <> "\nc\n")

      assert output =~ "Please type a single letter from a to z"
      assert output =~ "Good guess!"
      refute output =~ "turns left: 6"
    end
  end

  test "end of input quits cleanly" do
    assert play("cab", "") =~ "Goodbye!"
  end

  test "end of input in the middle of a game quits cleanly" do
    assert play("cab", "c\n") =~ "Goodbye!"
  end

  test "unreadable input quits cleanly" do
    assert play("cab", <<255, 10>>) =~ "Goodbye!"
  end
end
