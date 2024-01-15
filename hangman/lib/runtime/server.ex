defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  use GenServer


  # client process
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game}
  end

  def handle_call({ :make_move, guess }, _from, game) do
    { updated_game, tally } = Game.make_move(game, guess)
    { :reply, { :ok, tally }, update_game }
    end

end
