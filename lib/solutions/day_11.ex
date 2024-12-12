defmodule Solutions.Day11 do
  alias Util.Parsing

  @behaviour Solution

  @test_input """
  125 17
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  55312
  """
  def solve_part_1(input) do
    input
    |> stone_counts()
    |> blinking(25)
    |> Map.values()
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  65601038650482
  """
  def solve_part_2(input) do
    input
    |> stone_counts()
    |> blinking(75)
    |> Map.values()
    |> Enum.sum()
  end

  defp stone_counts(input) do
    input
    |> String.split()
    |> Parsing.integers()
    |> Map.new(&{&1, 1})
  end

  defp blinking(stone_counts, blinks) do
    stone_counts
    |> Stream.iterate(&blink/1)
    |> Enum.at(blinks)
  end

  defp blink(stone_counts) do
    stone_counts
    |> Enum.flat_map(fn {number, count} -> number |> transform() |> Enum.map(&{&1, count}) end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Map.new(fn {number, counts} -> {number, Enum.sum(counts)} end)
  end

  def transform(stone) do
    digits = Integer.digits(stone)
    count = length(digits)

    cond do
      stone == 0 ->
        [1]

      rem(count, 2) == 0 ->
        middle = div(count, 2)

        digits
        |> Enum.chunk_every(middle)
        |> Enum.map(&Integer.undigits/1)

      true ->
        [stone * 2024]
    end
  end
end
