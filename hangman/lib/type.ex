defmodule Hangman.Type do
  @type state :: :initializing  | :already_used | :won | :lost | :good_guess | :bad_guess | :bad_guess
 
  @type tally :: %{
    turns_left: integer,
    game_state: state,
    letters: list(String.t),
    used: MapSet.t(String.t)
  }

end
