defmodule AdventOfCode.Day3.Solution1 do
  @number_values ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
  @symbol_values ["+", "*", "%", "#", "/", "@", "$", "-", "&", "="]

  defmodule Number do
    defstruct value: nil, coords_list: []
  end

  defmodule Symbol do
    defstruct value: nil, coords: nil
  end

  def execute do
    %{numbers: numbers, symbols: symbols} =
      File.stream!("priv/3.txt")
      |> Stream.map(&String.trim_trailing/1)
      |> Stream.with_index()
      |> Stream.map(&build_structs/1)
      |> join_structs_lists()

    symbols_set =
      symbols
      |> Enum.map(fn symbol -> symbol.coords end)
      |> MapSet.new()

    numbers
    |> Enum.map(fn number ->
      if number_adjacent_to_symbol?(number.coords_list, symbols_set) do
        number.value
      else
        0
      end
    end)
    |> Enum.reduce(0, &+/2)
  end

  defp build_structs({line, y}) do
    %{numbers: numbers, symbols: symbols} =
      line
      |> String.graphemes()
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Enum.reduce(%{numbers: [], symbols: [], temp_value: "", temp_coords: []},
        fn
          {x, grapheme}, acc when grapheme in @symbol_values ->
            symbol = %Symbol{value: grapheme, coords: {x, y}}

            acc
            |> Map.update!(:symbols, fn symbols -> [symbol | symbols] end)
            |> maybe_add_number()

          {x, grapheme}, acc when grapheme in @number_values ->
            acc
            |> Map.update!(:temp_value, fn number -> number <> grapheme end)
            |> Map.update!(:temp_coords, fn coords -> [{x, y} | coords] end)

          _, acc ->
            maybe_add_number(acc)
        end)
        |> maybe_add_number()

    %{numbers: numbers, symbols: symbols}
  end

  defp maybe_add_number(%{temp_value: ""} = acc) do
    acc
  end
  defp maybe_add_number(acc) do
    number = %Number{
      value: String.to_integer(acc.temp_value),
      coords_list: acc.temp_coords
    }

    acc
    |> Map.update!(:numbers, fn numbers -> [number | numbers] end)
    |> Map.put(:temp_value, "")
    |> Map.put(:temp_coords, [])
  end

  def join_structs_lists(lists) do
    Enum.reduce(
      lists,
      %{numbers: [], symbols: []},
      fn %{numbers: line_numbers, symbols: line_symbols}, acc ->
        acc
        |> Map.update!(:numbers, fn numbers -> line_numbers ++ numbers end)
        |> Map.update!(:symbols, fn symbols -> line_symbols ++ symbols end)
      end
    )
  end

  defp number_adjacent_to_symbol?(coords, symbols_set) do
    coords_set =
      coords
      |> Enum.flat_map(fn {x, y} ->
        [
          {x - 1, y - 1},
          {x - 1, y},
          {x, y - 1},
          {x - 1, y + 1},
          {x + 1, y - 1},
          {x + 1, y},
          {x, y + 1},
          {x + 1, y + 1}
        ]
      end)
      |> MapSet.new()

    (coords_set |> MapSet.intersection(symbols_set) |> MapSet.size()) > 0
  end
end
