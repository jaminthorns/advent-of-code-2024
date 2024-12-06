defmodule Mix.Tasks.Inputs do
  @moduledoc "Fetch the puzzle input files for all implemented solutions."
  @shortdoc "Fetch all puzzle input files"

  use Mix.Task
  alias IO.ANSI

  @impl Mix.Task
  def run(_) do
    Application.ensure_all_started(:advent_of_code)

    unless File.exists?("inputs") do
      File.mkdir!("inputs")
    end

    for day <- Solution.implemented_days() do
      path = Input.path(day)

      if File.exists?(path) do
        IO.puts("Day #{day}: already exists")
      else
        case Input.get_input(day) do
          {:ok, input} ->
            File.write!(path, input)
            IO.puts("Day #{day}: created #{path}")

          {:error, :not_logged_in} ->
            IO.puts(:stderr, ANSI.red() <> "Day #{day}: not logged in")

          {:error, :not_yet_available} ->
            IO.puts(:stderr, ANSI.red() <> "Day #{day}: not yet available")

          {:error, _reason} ->
            IO.puts(:stderr, ANSI.red() <> "Day #{day}: unknown error")
        end
      end
    end
  end
end
