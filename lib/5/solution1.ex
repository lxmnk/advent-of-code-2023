defmodule AdventOfCode.Day5.Solution1 do
  def execute do
    stream = File.stream!("priv/5.txt")

    seeds =
      stream
      |> Enum.take(1)
      |> Enum.at(0)
      |> String.trim_trailing()
      |> build_seeds()

    range_map_lists =
      stream
      |> Stream.drop(1)
      |> Stream.map(&String.trim_trailing/1)
      |> build_range_map_lists()

    seeds
    |> map_seeds(range_map_lists)
    |> Enum.min()
  end

  defp build_seeds(line) do
    "seeds: " <> seeds_str = line

    seeds_str
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp build_range_map_lists(lines) do
    Enum.reduce(
      lines,
      [],
      fn
        "", acc ->
          acc

        <<symbol::binary-size(1), _::binary>>, acc
            when symbol not in ~w(0 1 2 3 4 5 6 7 8 9) ->
          [[] | acc]

        line, [head | rest] ->
          [dst_start, src_start, len] =
            line
            |> String.split()
            |> Enum.map(&String.to_integer/1)

          src = src_start..(src_start + len - 1)
          diff = dst_start - src_start

          [[{src, diff} | head] | rest]
    end)
    |> Enum.reverse()
  end

  defp map_seeds(seeds, range_map_lists) do
    Enum.reduce(range_map_lists, seeds, fn range_map_list, acc ->
      Enum.map(acc, fn seed ->
        case Enum.find(range_map_list, fn {range, _} -> seed in range end) do
          nil -> seed
          {_, diff} -> seed + diff
        end
      end)
    end)
  end
end
