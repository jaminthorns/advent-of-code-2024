defmodule Solutions.Day2 do
  @behaviour Solution

  @test_input """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  2
  """
  def solve_part_1(input) do
    input
    |> reports()
    |> Enum.count(&safe?/1)
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  4
  """
  def solve_part_2(input) do
    input
    |> reports()
    |> Enum.count(fn report -> report |> remove_single() |> Enum.any?(&safe?/1) end)
  end

  defp reports(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end

  defp safe?(report) do
    consecutives = Enum.zip(report, Enum.drop(report, 1))

    all_increasing = Enum.all?(consecutives, fn {prev, curr} -> prev < curr end)
    all_decreasing = Enum.all?(consecutives, fn {prev, curr} -> prev > curr end)

    {min_diff, max_diff} =
      consecutives
      |> Enum.map(fn {prev, curr} -> abs(prev - curr) end)
      |> Enum.min_max()

    (all_increasing or all_decreasing) and min_diff >= 1 and max_diff <= 3
  end

  defp remove_single(report) do
    for i <- 0..(length(report) - 1) do
      List.delete_at(report, i)
    end
  end
end
