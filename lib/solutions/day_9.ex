defmodule Solutions.Day9 do
  alias Util.Parsing

  @behaviour Solution

  @test_input """
  2333133121414131402
  """

  @doc """
  iex> solve_part_1(#{inspect(@test_input)})
  1928
  """
  def solve_part_1(input) do
    input
    |> disk_map()
    |> expand()
    |> compact_blocks()
    |> checksum()
  end

  @doc """
  iex> solve_part_2(#{inspect(@test_input)})
  2858
  """
  def solve_part_2(input) do
    input
    |> disk_map()
    |> expand()
    |> compact_files()
    |> checksum()
  end

  defp disk_map(input) do
    input
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Parsing.integers()
  end

  defp expand(disk_map) do
    disk_map
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {file_size, index} when rem(index, 2) == 0 -> List.duplicate(div(index, 2), file_size)
      {free_size, index} when rem(index, 2) == 1 -> List.duplicate(nil, free_size)
    end)
  end

  defp compact_blocks(disk) do
    free = Enum.count(disk, &is_nil/1)
    end_blocks = disk |> Enum.reverse() |> Enum.reject(&is_nil/1) |> Enum.take(free)

    disk
    |> Enum.drop(-free)
    |> Enum.map_reduce(end_blocks, fn
      nil, [block | end_blocks] -> {block, end_blocks}
      block, end_blocks -> {block, end_blocks}
    end)
    |> elem(0)
  end

  defp compact_files(disk) do
    chunked_disk = Enum.chunk_by(disk, & &1)

    chunked_disk
    |> Enum.reject(&match?([nil | _], &1))
    |> Enum.reverse()
    |> Enum.reduce(chunked_disk, fn [file_id | _] = file, chunked_disk ->
      file_size = length(file)
      free_index = Enum.find_index(chunked_disk, &file_fits?(&1, file_size))

      cond do
        is_nil(free_index) ->
          chunked_disk

        chunked_disk |> Enum.at(free_index + 1) |> List.first() > file_id ->
          chunked_disk

        true ->
          free_size = chunked_disk |> Enum.at(free_index) |> length()
          file_index = Enum.find_index(chunked_disk, &(&1 == file))
          new_free_size = free_size - file_size

          chunked_disk =
            chunked_disk
            |> List.replace_at(free_index, file)
            |> List.replace_at(file_index, List.duplicate(nil, file_size))

          chunked_disk =
            if new_free_size > 0 do
              new_free = List.duplicate(nil, new_free_size)
              List.insert_at(chunked_disk, free_index + 1, new_free)
            else
              chunked_disk
            end

          chunked_disk
      end
    end)
    |> List.flatten()
  end

  defp file_fits?([nil | _] = free_space, file_size), do: length(free_space) >= file_size
  defp file_fits?(_file, _file_size), do: false

  defp checksum(disk) do
    disk
    |> Enum.with_index()
    |> Enum.map(fn {file, index} -> (file || 0) * index end)
    |> Enum.sum()
  end
end
