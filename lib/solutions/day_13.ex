defmodule Solutions.Day13 do
  @behaviour Solution

  @test_input """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """

  @button_pattern ~r/Button .: X\+(?<x>\d+), Y\+(?<y>\d+)/
  @prize_pattern ~r/Prize: X=(?<x>\d+), Y=(?<y>\d+)/

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  480
  """
  def solve_part_1(input) do
    input
    |> behaviors()
    |> Enum.map(&minimum_button_pushes/1)
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  875318608908
  """
  def solve_part_2(input) do
    input
    |> behaviors()
    |> Enum.map(&add_to_prize/1)
    |> Enum.map(&minimum_button_pushes/1)
    |> Enum.sum()
  end

  defp behaviors(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn machine ->
      [button_a, button_b, prize] = String.split(machine, "\n", trim: true)

      button_a = Regex.named_captures(@button_pattern, button_a)
      button_b = Regex.named_captures(@button_pattern, button_b)
      prize = Regex.named_captures(@prize_pattern, prize)

      %{
        a: %{x: String.to_integer(button_a["x"]), y: String.to_integer(button_a["y"])},
        b: %{x: String.to_integer(button_b["x"]), y: String.to_integer(button_b["y"])},
        prize: %{x: String.to_integer(prize["x"]), y: String.to_integer(prize["y"])}
      }
    end)
  end

  defp minimum_button_pushes(%{a: a, b: b, prize: prize}) do
    # Do math.
    b_pushes = (prize.y * a.x - a.y * prize.x) / (b.y * a.x - b.x * a.y)
    a_pushes = (prize.x - b.x * b_pushes) / a.x

    if a_pushes == floor(a_pushes) and b_pushes == floor(b_pushes),
      do: floor(a_pushes) * 3 + floor(b_pushes) * 1,
      else: 0
  end

  defp add_to_prize(behavior) do
    add = &(&1 + 10_000_000_000_000)

    behavior
    |> update_in([:prize, :x], add)
    |> update_in([:prize, :y], add)
  end
end
