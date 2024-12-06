defmodule Mix.Tasks.Start do
  @moduledoc "Create a new `Solution` module and input file for a given day."
  @shortdoc "Create files for a new solution"

  use Mix.Task
  alias IO.ANSI

  @impl Mix.Task
  def run([day]) do
    Application.ensure_all_started(:advent_of_code)

    year = Application.get_env(:advent_of_code, :year)
    module_path = "lib/solutions/day_#{day}.ex"
    input_path = Input.path(day)

    module_content = EEx.eval_file("priv/day_template.eex", day: day)

    case Input.get_input(day) do
      {:ok, input} ->
        File.write!(module_path, module_content)
        File.write!(input_path, input)

        IO.puts("Created #{module_path}")
        IO.puts("Created #{input_path}")
        IO.puts("Instructions: https://adventofcode.com/#{year}/day/#{day}")

      {:error, :not_logged_in} ->
        IO.puts(:stderr, ANSI.red() <> "You are not logged in.")

      {:error, :not_yet_available} ->
        IO.puts(:stderr, ANSI.red() <> "This day is not yet available.")

      {:error, reason} ->
        IO.puts(:stderr, ANSI.red() <> "An error occurred: #{inspect(reason)}")
    end
  end
end
