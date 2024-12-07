defmodule Solutions.Day6 do
  alias Util.Grid

  @behaviour Solution

  @test_input """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  41
  """
  def solve_part_1(input) do
    map = Grid.new(input)
    start_position = start_position(map)
    start_direction = Grid.up()

    map
    |> path(start_position, start_direction)
    |> Stream.uniq_by(&elem(&1, 0))
    |> Enum.count()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  6
  """
  def solve_part_2(input) do
    map = Grid.new(input)
    start_position = start_position(map)
    start_direction = Grid.up()
    original_path = path(map, start_position, start_direction)

    map
    |> obstructed_maps(original_path)
    |> Task.async_stream(fn obstructed_map ->
      obstructed_map
      |> path(start_position, start_direction)
      |> repeats?()
    end)
    |> Enum.count(&match?({:ok, true}, &1))
  end

  defp start_position(map) do
    map
    |> Enum.find(fn {_, symbol} -> symbol == "^" end)
    |> elem(0)
  end

  defp path(map, start_position, start_direction) do
    Stream.unfold({start_position, start_direction}, fn
      :halt ->
        nil

      {start, direction} ->
        positions =
          start
          |> Grid.forward(direction)
          |> Enum.take_while(&(Map.get(map, &1) in [".", "^"]))

        last = List.last(positions, start)
        next = Grid.step(last, direction)
        steps = Enum.map(positions, &{&1, direction})

        if Map.has_key?(map, next),
          do: {steps, {last, Grid.rotate_right(direction)}},
          else: {steps, :halt}
    end)
    |> Stream.flat_map(&Function.identity/1)
  end

  defp obstructed_maps(map, original_path) do
    original_path
    |> Stream.map(&elem(&1, 0))
    |> Stream.uniq()
    |> Stream.reject(&(Map.get(map, &1) == "^"))
    |> Stream.map(&Map.put(map, &1, "#"))
  end

  defp repeats?(path) do
    Enum.reduce_while(path, {false, MapSet.new()}, fn step, {_, visited} ->
      if step in visited,
        do: {:halt, {true, visited}},
        else: {:cont, {false, MapSet.put(visited, step)}}
    end)
    |> elem(0)
  end
end
