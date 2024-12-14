defmodule Solutions.Day12 do
  alias Util.Grid

  @behaviour Solution

  @test_input_1 """
  AAAA
  BBCD
  BBCC
  EEEC
  """

  @test_input_2 """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @test_input_3 """
  EEEEE
  EXXXX
  EEEEE
  EXXXX
  EEEEE
  """

  @test_input_4 """
  AAAAAA
  AAABBA
  AAABBA
  ABBAAA
  ABBAAA
  AAAAAA
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input_1)})
  140

  iex> solve_part_1(#{inspect(@test_input_2)})
  1930
  """
  def solve_part_1(input) do
    map = Grid.new(input)

    map
    |> regions()
    |> Enum.map(&section_price(&1, map))
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input_1)})
  80

  iex> solve_part_2(#{inspect(@test_input_2)})
  1206

  iex> solve_part_2(#{inspect(@test_input_3)})
  236

  iex> solve_part_2(#{inspect(@test_input_4)})
  368
  """
  def solve_part_2(input) do
    map = Grid.new(input)

    map
    |> regions()
    |> Enum.map(&bulk_price(&1, map))
    |> Enum.sum()
  end

  defp regions(map) do
    positions = map |> Map.keys() |> MapSet.new()
    do_regions([], positions, map)
  end

  defp do_regions(regions, positions, map) do
    case Enum.at(positions, 0) do
      nil ->
        regions

      position ->
        {plant, region} = region(position, map)
        positions = MapSet.difference(positions, region)

        do_regions([{plant, region} | regions], positions, map)
    end
  end

  defp region(position, map) do
    plant = Map.get(map, position)
    init_region = MapSet.new([position])

    do_region(init_region, init_region, map, plant)
  end

  defp do_region(region, edge, map, plant) do
    new_edge =
      edge
      |> Enum.flat_map(&outward/1)
      |> Enum.reject(&(&1 in region))
      |> Enum.filter(&(Map.get(map, &1) == plant))
      |> MapSet.new()

    new_region = MapSet.union(region, new_edge)

    if region == new_region,
      do: {plant, region},
      else: do_region(new_region, new_edge, map, plant)
  end

  defp outward(position), do: Enum.map(Grid.cardinal_directions(), &Grid.step(position, &1))

  defp section_price({plant, region}, map) do
    sections =
      region
      |> Enum.map(fn position -> position |> sections(map, plant) |> Enum.count() end)
      |> Enum.sum()

    MapSet.size(region) * sections
  end

  defp bulk_price({plant, region}, map) do
    {horizontal, vertical} =
      region
      |> Enum.flat_map(&sections(&1, map, plant))
      |> Enum.split_with(&match?({_, {0, _}}, &1))

    hori_sides = side_count(horizontal, fn {{_, y}, dir} -> {y, dir} end, fn {{x, _}, _} -> x end)
    vert_sides = side_count(vertical, fn {{x, _}, dir} -> {x, dir} end, fn {{_, y}, _} -> y end)

    MapSet.size(region) * (hori_sides + vert_sides)
  end

  defp side_count(positions, key_fun, value_fun) do
    positions
    |> Enum.group_by(key_fun, value_fun)
    |> Map.values()
    |> Enum.flat_map(&chunk_contiguous/1)
    |> Enum.count()
  end

  defp chunk_contiguous(numbers) do
    Enum.chunk_while(
      numbers,
      [],
      fn number, chunk ->
        cond do
          Enum.empty?(chunk) -> {:cont, [number]}
          List.first(chunk) + 1 == number -> {:cont, [number | chunk]}
          true -> {:cont, chunk, [number]}
        end
      end,
      fn
        [] -> {:cont, nil}
        chunk -> {:cont, chunk, nil}
      end
    )
  end

  defp sections(position, map, plant) do
    Grid.cardinal_directions()
    |> Enum.map(&{Grid.step(position, &1), &1})
    |> Enum.filter(fn {position, _} -> Map.get(map, position) != plant end)
  end
end
