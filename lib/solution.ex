defmodule Solution do
  @callback solve_part_1(input :: binary) :: any
  @callback solve_part_2(input :: binary) :: any

  @doc """
  Solve a puzzle for a given `day` and `part`.
  """
  def solve(day) do
    module = Module.concat(["Solutions", "Day#{day}"])
    input = day |> Input.path() |> File.read!()

    {module.solve_part_1(input), module.solve_part_2(input)}
  end

  @doc """
  Get the day numbers of all implemented solutions.
  """
  def implemented_days do
    :advent_of_code
    |> Application.spec(:modules)
    |> Enum.map(&Module.split/1)
    |> Enum.filter(&(List.first(&1) == "Solutions"))
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.map(&String.replace(&1, "Day", ""))
    |> Enum.map(&String.to_integer/1)
  end
end
