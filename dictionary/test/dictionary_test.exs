defmodule DictionaryTest do
  use ExUnit.Case

  alias Dictionary.Impl.WordList

  doctest Dictionary

  test "the word server starts with the application" do
    assert is_pid(Process.whereis(Dictionary.Runtime.Server))
  end

  test "random_word returns a word from the list" do
    assert Dictionary.random_word() in WordList.word_list()
  end

  test "the word list only contains lowercase English letters" do
    words = WordList.word_list()

    refute Enum.empty?(words)
    assert Enum.reject(words, &(&1 =~ ~r/\A[a-z]+\z/)) == []
  end

  test "the word list has no duplicates" do
    words = WordList.word_list()

    assert words -- Enum.uniq(words) == []
  end

  test "random_word picks from the list it receives" do
    assert WordList.random_word(["wombat"]) == "wombat"
  end

  test "the word server is restarted if it crashes" do
    old = Process.whereis(Dictionary.Runtime.Server)
    ref = Process.monitor(old)
    Process.exit(old, :kill)
    assert_receive {:DOWN, ^ref, :process, ^old, :killed}

    # which_children is answered only after the supervisor has handled the exit
    assert [{_, new, :worker, _}] = Supervisor.which_children(Dictionary.Runtime.Supervisor)
    assert is_pid(new) and new != old
    assert is_binary(Dictionary.random_word())
  end
end
