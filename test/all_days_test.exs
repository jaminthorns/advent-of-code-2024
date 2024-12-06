defmodule AllDaysTest do
  use ExUnit.Case

  for day <- Solution.implemented_days() do
    doctest Module.concat("Solutions", "Day#{day}"),
      import: true,
      tags: [String.to_atom("day_#{day}")]
  end
end
