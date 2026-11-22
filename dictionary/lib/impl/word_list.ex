defmodule Dictionary.Impl.WordList do

  @type t :: list(String.t)

  # Read at compile time, so the app doesn't need the source tree to run
  @words_file Path.expand("../../assets/words.txt", __DIR__)
  @external_resource @words_file
  @words @words_file |> File.read!() |> String.split()

  @spec word_list :: t
  def word_list, do: @words

  @spec random_word(t) :: String.t
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end
end
