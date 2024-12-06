defmodule Util.Grid do
  def new(input) do
    for {line, y} <- input |> String.split() |> Enum.with_index(),
        {char, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new() do
      {{x, y}, char}
    end
  end

  def forward(position, direction), do: Stream.iterate(position, &step(&1, direction))

  def step({x, y}, {dx, dy}), do: {x + dx, y + dy}

  def up, do: {0, -1}
  def down, do: {0, 1}
  def left, do: {-1, 0}
  def right, do: {1, 0}

  def rotate_right({0, -1}), do: {1, 0}
  def rotate_right({1, 0}), do: {0, 1}
  def rotate_right({0, 1}), do: {-1, 0}
  def rotate_right({-1, 0}), do: {0, -1}

  def rotate_left({0, -1}), do: {-1, 0}
  def rotate_left({-1, 0}), do: {0, 1}
  def rotate_left({0, 1}), do: {1, 0}
  def rotate_left({1, 0}), do: {0, -1}
end
