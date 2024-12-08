defmodule Solutions.Day8 do
  alias Util.Grid
  alias Util.Sets

  @behaviour Solution

  @test_input """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  14
  """
  def solve_part_1(input) do
    input
    |> Grid.new()
    |> antenna_antinodes(1)
    |> Enum.count()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  34
  """
  def solve_part_2(input) do
    input
    |> Grid.new()
    |> antenna_antinodes()
    |> Enum.count()
  end

  defp antenna_antinodes(map, limit \\ nil) do
    for antennas <- antenna_groups(map),
        [antenna_1, antenna_2] <- Sets.combinations(antennas, 2),
        antinode <- pair_antinodes(antenna_1, antenna_2, map, limit),
        uniq: true do
      antinode
    end
  end

  defp antenna_groups(map) do
    map
    |> Enum.filter(fn {_, symbol} -> String.match?(symbol, ~r/[a-zA-Z0-9]/) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.group_by(&Map.get(map, &1))
    |> Map.values()
  end

  defp pair_antinodes({x1, y1}, {x2, y2}, map, limit) do
    from_1 = antinodes({x1, y1}, {x1 - x2, y1 - y2}, map, limit)
    from_2 = antinodes({x2, y2}, {x2 - x1, y2 - y1}, map, limit)

    from_1 ++ from_2
  end

  def antinodes(position, translation, map, limit) do
    antinodes =
      position
      |> Grid.forward(translation)
      |> Enum.take_while(&Map.has_key?(map, &1))

    if is_nil(limit),
      do: antinodes,
      else: antinodes |> Enum.drop(1) |> Enum.take(limit)
  end
end
