defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game()
  @typep tally :: Hangman.Type.tally()
  @typep state :: {game, tally}

  @spec start :: :ok
  def start() do
    game = Hangman.new_game
    tally = Hangman.tally(game)
    interact({ game, tally })
  end

  @spec interact(state) :: :ok 
  def interact({_game, tally = %{game_state: :won}}) do
    IO.puts("Congratulations. You won! The word was #{tally.letters |> Enum.join()}")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... the word was #{tally.letters |> Enum.join()}")
  end

  def interact({ game, tally }) do
    IO.puts feedback_for(tally)
    IO.puts(current_word(tally))

    case get_guess() do
      :quit ->
        IO.puts("\nGoodbye!")

      {:ok, guess} ->
        interact({ game, Hangman.make_move(game, guess) })
    end
  end

  ################################################## 
  
  def feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I'm thinking of a word with #{tally.letters |> length} letters"
  end

  def feedback_for(%{game_state: :good_guess}), do: "Good guess!"
  def feedback_for(%{game_state: :bad_guess}), do: "Sorry, that letter's not in the word"
  def feedback_for(%{game_state: :already_used}), do: "You already used that letter"

  def current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      "   turns left: ",
      tally.turns_left |> to_string,
      "   used so far: ",
      tally.used |> Enum.join(",")
    ]
  end

  @spec get_guess :: {:ok, String.t()} | :quit
  def get_guess() do
    IO.gets("Next letter: ")
    |> parse_input()
  end

  # IO.gets returns :eof on Ctrl-D and {:error, reason} if input can't be read
  defp parse_input(input) when is_binary(input) do
    guess = input |> String.trim() |> String.downcase()

    if guess =~ ~r/\A[a-z]\z/ do
      {:ok, guess}
    else
      IO.puts("Please type a single letter from a to z")
      get_guess()
    end
  end

  defp parse_input(_eof_or_error), do: :quit
end
