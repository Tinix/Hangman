defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  use GenServer


  # client process
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end
end
