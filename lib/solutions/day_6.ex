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
    info = info(map)
    start_position = start_position(map)
    start_direction = Grid.up()

    info
    |> path_points(start_position, start_direction)
    |> materialize_path()
    |> Stream.uniq()
    |> Enum.count()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  6
  """
  def solve_part_2(input) do
    map = Grid.new(input)
    info = info(map)
    start_position = start_position(map)
    start_direction = Grid.up()

    map
    |> possible_obstructions()
    |> Enum.count(fn obstruction ->
      info
      |> add_obstruction(obstruction)
      |> path_points(start_position, start_direction)
      |> repeats?()
    end)
  end

  defp start_position(map) do
    map
    |> Enum.find(fn {_, symbol} -> symbol == "^" end)
    |> elem(0)
  end

  defp info(map) do
    positions =
      map
      |> Map.filter(fn {_, symbol} -> symbol == "#" end)
      |> Map.keys()
      |> Enum.sort()

    {max_x, max_y} = map |> Map.keys() |> Enum.max()
    columns = Enum.group_by(positions, fn {x, _} -> x end, fn {_, y} -> y end)
    rows = Enum.group_by(positions, fn {_, y} -> y end, fn {x, _} -> x end)

    %{
      bounds: %{
        x: %{-1 => 0, 1 => max_x},
        y: %{-1 => 0, 1 => max_y}
      },
      obstacles: %{
        columns: create_reverse(columns),
        rows: create_reverse(rows)
      }
    }
  end

  defp create_reverse(line) do
    Map.new(line, fn {row_or_column, obstacles} ->
      {row_or_column, %{-1 => Enum.reverse(obstacles), 1 => obstacles}}
    end)
  end

  defp add_obstruction(info, {x, y}) do
    empty = %{-1 => [], 1 => []}

    info
    |> update_in([:obstacles, :columns, Access.key(y, empty), -1], &Enum.sort([x | &1], :desc))
    |> update_in([:obstacles, :columns, Access.key(y, empty), 1], &Enum.sort([x | &1]))
    |> update_in([:obstacles, :rows, Access.key(x, empty), -1], &Enum.sort([y | &1], :desc))
    |> update_in([:obstacles, :rows, Access.key(x, empty), 1], &Enum.sort([y | &1]))
  end

  defp path_points(%{bounds: bounds, obstacles: obstacles}, start_position, start_direction) do
    points =
      Stream.unfold({start_position, start_direction}, fn
        :halt ->
          nil

        {{x, y}, direction} ->
          case direction do
            {x_direction, 0} ->
              case next_obstacle(obstacles.rows[y][x_direction] || [], x, x_direction) do
                nil -> {:halt, {bounds.x[x_direction], y}}
                next_x -> {:cont, {next_x - x_direction, y}}
              end

            {0, y_direction} ->
              case next_obstacle(obstacles.columns[x][y_direction] || [], y, y_direction) do
                nil -> {:halt, {x, bounds.y[y_direction]}}
                next_y -> {:cont, {x, next_y - y_direction}}
              end
          end
          |> case do
            {:halt, last} -> {last, :halt}
            {:cont, last} -> {last, {last, Grid.rotate_right(direction)}}
          end
      end)

    Stream.concat([start_position], points)
  end

  defp next_obstacle(obstacles, start, -1), do: Enum.find(obstacles, &(&1 < start))
  defp next_obstacle(obstacles, start, 1), do: Enum.find(obstacles, &(&1 > start))

  defp materialize_path(path_points) do
    path_points = Enum.to_list(path_points)

    path_points
    |> Enum.zip(Enum.drop(path_points, 1))
    |> Enum.flat_map(fn {{x1, y1}, {x2, y2}} -> for x <- x1..x2, y <- y1..y2, do: {x, y} end)
  end

  defp possible_obstructions(map) do
    map
    |> Enum.filter(fn {_, symbol} -> symbol == "." end)
    |> Enum.map(&elem(&1, 0))
  end

  defp repeats?(path_points) do
    Enum.reduce_while(path_points, {false, MapSet.new()}, fn position, {_, visited} ->
      if MapSet.member?(visited, position),
        do: {:halt, {true, visited}},
        else: {:cont, {false, MapSet.put(visited, position)}}
    end)
    |> elem(0)
  end
end
