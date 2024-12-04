defmodule Solutions.Day4 do
  @behaviour Solution

  @test_input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  18
  """
  def solve_part_1(input) do
    word_search = word_search(input)

    word_search
    |> letter_positions("X")
    |> Enum.flat_map(&outward_words(&1, word_search, 4))
    |> Enum.count(&(&1 == "XMAS"))
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  9
  """
  def solve_part_2(input) do
    word_search = word_search(input)

    word_search
    |> letter_positions("A")
    |> Enum.map(&cross_words(&1, word_search, 3))
    |> Enum.count(fn word -> Enum.count(word, &(&1 == "MAS")) == 2 end)
  end

  defp word_search(input) do
    for {line, y} <- input |> String.split() |> Enum.with_index(),
        {letter, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new() do
      {{x, y}, letter}
    end
  end

  defp letter_positions(word_search, letter) do
    word_search
    |> Map.filter(fn {_, l} -> l == letter end)
    |> Map.keys()
  end

  defp outward_words(position, word_search, length) do
    for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dx != 0 or dy != 0 do
      position
      |> outward(dx, dy)
      |> Enum.take(length)
      |> Enum.map(&Map.get(word_search, &1))
      |> Enum.join()
    end
  end

  defp cross_words(position, word_search, length) do
    half_length = div(length, 2)

    for dx <- [-1, 1], dy <- [-1, 1] do
      front_half = position |> outward(-dx, -dy) |> Enum.take(half_length + 1) |> Enum.reverse()
      back_half = position |> outward(dx, dy) |> Stream.drop(1) |> Enum.take(half_length)

      front_half
      |> Enum.concat(back_half)
      |> Enum.map(&Map.get(word_search, &1))
      |> Enum.join()
    end
  end

  defp outward(position, dx, dy) do
    Stream.iterate(position, fn {x, y} -> {x + dx, y + dy} end)
  end
end
