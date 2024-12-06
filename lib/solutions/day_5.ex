defmodule Solutions.Day5 do
  alias Util.Parsing

  @behaviour Solution

  @test_input """
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  143
  """
  def solve_part_1(input) do
    {rules, updates} = pages(input)

    updates
    |> Enum.filter(&(&1 == sort_update(&1, rules)))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  123
  """
  def solve_part_2(input) do
    {rules, updates} = pages(input)

    updates
    |> Enum.map(&{&1, sort_update(&1, rules)})
    |> Enum.filter(fn {unsorted, sorted} -> unsorted != sorted end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  defp pages(input) do
    [rules, updates] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split()
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(&Parsing.integers/1)

    updates =
      updates
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&Parsing.integers/1)

    {rules, updates}
  end

  defp sort_update(update, rules) do
    Enum.sort(update, fn a, b -> not Enum.any?(rules, &(&1 == [b, a])) end)
  end

  defp middle_page(rule) do
    middle_index = rule |> length() |> div(2)
    Enum.at(rule, middle_index)
  end
end
