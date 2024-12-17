defmodule Solutions.Day14 do
  alias Util.Grid
  @behaviour Solution

  @test_input """
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)}, 11, 7)
  12
  """
  def solve_part_1(input, width \\ 101, height \\ 103) do
    input
    |> robots()
    |> Stream.iterate(&step(&1, width, height))
    |> Enum.at(100)
    |> safety_factor(width, height)
  end

  def solve_part_2(input) do
    input
    |> robots()
    |> Stream.iterate(&step(&1, 101, 103))
    |> Enum.find_index(&any_robot_surrounded?/1)
  end

  defp robots(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [px, py, vx, vy] = Regex.run(~r/p=(.+),(.+) v=(.+),(.+)/, line, capture: :all_but_first)

      %{
        position: {String.to_integer(px), String.to_integer(py)},
        velocity: {String.to_integer(vx), String.to_integer(vy)}
      }
    end)
  end

  defp step(robots, width, height) do
    robots
    |> Enum.map(&%{&1 | position: Grid.step(&1.position, &1.velocity)})
    |> Enum.map(&wrap(&1, width, height))
  end

  defp wrap(%{position: {x, y}} = robot, width, height) do
    %{robot | position: {rem(x + width, width), rem(y + height, height)}}
  end

  defp safety_factor(robots, width, height) do
    positions = Enum.map(robots, & &1.position)
    h_middle = div(width, 2)
    v_middle = div(height, 2)

    nw_quadrant = Enum.count(positions, fn {x, y} -> x < h_middle and y < v_middle end)
    ne_quadrant = Enum.count(positions, fn {x, y} -> x > h_middle and y < v_middle end)
    sw_quadrant = Enum.count(positions, fn {x, y} -> x < h_middle and y > v_middle end)
    se_quadrant = Enum.count(positions, fn {x, y} -> x > h_middle and y > v_middle end)

    nw_quadrant * ne_quadrant * sw_quadrant * se_quadrant
  end

  defp any_robot_surrounded?(robots) do
    positions = MapSet.new(robots, & &1.position)

    Enum.any?(robots, fn robot ->
      Enum.all?(Grid.all_directions(), fn direction ->
        Grid.step(robot.position, direction) in positions
      end)
    end)
  end
end
