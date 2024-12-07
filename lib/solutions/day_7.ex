defmodule Solutions.Day7 do
  alias Util.Parsing
  @behaviour Solution

  @test_input """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  3749
  """
  def solve_part_1(input) do
    input
    |> calibrations()
    |> Enum.filter(&possible?(&1, [:add, :mult]))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  11387
  """
  def solve_part_2(input) do
    input
    |> calibrations()
    |> Enum.filter(&possible?(&1, [:add, :mult, :concat]))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp calibrations(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [value, numbers] = String.split(line, ":")
      value = String.to_integer(value)
      numbers = numbers |> String.split() |> Parsing.integers()

      {value, numbers}
    end)
  end

  defp possible?(calibration, operators, acc \\ nil)
  defp possible?({value, []}, _operators, acc), do: acc == value

  defp possible?({value, [number | rest]}, operators, acc) do
    Enum.any?(operators, fn
      :add -> possible?({value, rest}, operators, (acc || 0) + number)
      :mult -> possible?({value, rest}, operators, (acc || 1) * number)
      :concat -> possible?({value, rest}, operators, concat(acc, number))
    end)
  end

  defp concat(a, nil), do: a
  defp concat(nil, b), do: b
  defp concat(a, b), do: Integer.undigits(Integer.digits(a) ++ Integer.digits(b))
end
