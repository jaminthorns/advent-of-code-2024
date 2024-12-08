defmodule Util.Sets do
  @doc """
  Generate all combinations of length `choose` as a `Stream`.
  """
  def combinations(enumerable, choose), do: combinations(enumerable, choose, [])

  defp combinations(_enumerable, 0, combination), do: [combination]

  defp combinations(enumerable, choose, combination) do
    start_of_last_combination = length(enumerable) - choose

    Stream.transform(0..start_of_last_combination, enumerable, fn _, [element | rest] ->
      {combinations(rest, choose - 1, [element | combination]), rest}
    end)
  end
end
