defmodule Solutions.Day10 do
  alias Util.Grid

  @behaviour Solution

  @test_input """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  36
  """
  def solve_part_1(input) do
    map = Grid.new(input, &String.to_integer/1)

    map
    |> trailheads()
    |> Enum.map(&trails(&1, map))
    |> Enum.map(&trail_ends_count/1)
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  81
  """
  def solve_part_2(input) do
    map = Grid.new(input, &String.to_integer/1)

    map
    |> trailheads()
    |> Enum.map(&trails(&1, map))
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp trailheads(map) do
    map
    |> Enum.filter(&match?({_, 0}, &1))
    |> Enum.map(&elem(&1, 0))
  end

  defp trails(current, map, trail \\ []) do
    trail = [current | trail]

    case Map.get(map, current) do
      9 ->
        [trail]

      height ->
        Grid.cardinal_directions()
        |> Enum.map(&Grid.step(current, &1))
        |> Enum.filter(&(Map.get(map, &1) == height + 1))
        |> Enum.flat_map(&trails(&1, map, trail))
    end
  end

  defp trail_ends_count(trails) do
    trails
    |> Enum.uniq_by(&List.first/1)
    |> Enum.count()
  end
end
