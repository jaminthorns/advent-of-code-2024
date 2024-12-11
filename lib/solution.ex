defmodule Solution do
  @callback solve_part_1(input :: binary) :: any
  @callback solve_part_2(input :: binary) :: any

  @doc """
  Solve both parts of a puzzle for a given `day`.
  """
  def solve(day) do
    module = module(day)
    input = Input.read(day)

    {module.solve_part_1(input), module.solve_part_2(input)}
  end

  @doc """
  Solve a puzzle for a given `day` and `part`.
  """
  def solve(day, part) do
    module = module(day)
    input = Input.read(day)

    case part do
      1 -> module.solve_part_1(input)
      2 -> module.solve_part_2(input)
    end
  end

  defp module(day), do: Module.concat(["Solutions", "Day#{day}"])

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
    |> Enum.sort()
  end
end
