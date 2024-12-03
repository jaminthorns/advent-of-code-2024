defmodule Solutions.Day3 do
  @behaviour Solution

  @test_input_1 """
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input_1)})
  161
  """
  def solve_part_1(input) do
    input
    |> instructions()
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  @test_input_2 """
  xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  """

  @doc """
  iex> solve_part_2(#{inspect(@test_input_2)})
  48
  """
  def solve_part_2(input) do
    input
    |> remove_disabled()
    |> instructions()
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  defp remove_disabled(input) do
    Regex.replace(~r/don't\(\)(?:.*?do\(\)|.*)/s, input, "")
  end

  defp instructions(input) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(input)
    |> Enum.map(fn [_, x, y] -> {String.to_integer(x), String.to_integer(y)} end)
  end
end
