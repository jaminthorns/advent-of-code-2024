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
    |> stones()
    |> blinks(25)
    |> Enum.count()
  end

  # @doc """
  # iex> solve_part_2(#{inspect(@test_input)})
  # nil
  # """
  def solve_part_2(input) do
    input
    |> stones()
    |> blinks(75)
    |> Enum.count()
  end

  defp stones(input) do
    input
    |> String.split()
    |> Parsing.integers()
  end

  defp blinks(stones, count) do
    stones
    |> Stream.iterate(&blink/1)
    |> Enum.at(count)
  end

  defp blink(stones), do: Enum.flat_map(stones, &transform/1)

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
