defmodule Solutions.Day1 do
  @behaviour Solution

  @test_input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  11
  """
  def solve_part_1(input) do
    {left, right} = lists(input)
    left = Enum.sort(left)
    right = Enum.sort(right)

    left
    |> Enum.zip(right)
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  31
  """
  def solve_part_2(input) do
    {left, right} = lists(input)
    frequencies = Enum.frequencies(right)

    left
    |> Enum.map(&(&1 * Map.get(frequencies, &1, 0)))
    |> Enum.sum()
  end

  defp lists(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.reduce({[], []}, fn [left, right], {lefts, rights} ->
      lefts = [String.to_integer(left) | lefts]
      rights = [String.to_integer(right) | rights]

      {lefts, rights}
    end)
  end
end
