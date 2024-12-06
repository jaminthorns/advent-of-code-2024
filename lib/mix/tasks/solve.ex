defmodule Mix.Tasks.Solve do
  @moduledoc "Solve a puzzle for a specific day."
  @shortdoc "Solve a puzzle"

  use Mix.Task
  alias IO.ANSI

  @impl Mix.Task
  def run([day]) do
    Application.ensure_all_started(:advent_of_code)

    if String.to_integer(day) in Solution.implemented_days() do
      {part_1_solution, part_2_solution} = Solution.solve(day)

      IO.puts("Part 1: #{inspect(part_1_solution)}")
      IO.puts("Part 2: #{inspect(part_2_solution)}")
    else
      IO.puts(:stderr, ANSI.red() <> "This day is not yet implemented.")
    end
  end
end
