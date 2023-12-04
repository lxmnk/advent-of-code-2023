defmodule AdventOfCode.Day3.Solution2 do
  @number_values ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

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

    numbers_map =
      numbers
      |> Enum.flat_map(fn number ->
        Enum.map(number.coords_list, fn coord ->
          {coord, number}
        end)
      end)
      |> Enum.into(%{})

    Enum.reduce(symbols, 0, fn symbol, acc ->
      case get_adjacent_numbers(symbol.coords, numbers_map) do
        [a | [b]] ->
          acc + (a * b)

        _ ->
          acc
      end
    end)
  end

  defp build_structs({line, y}) do
    %{numbers: numbers, symbols: symbols} =
      line
      |> String.graphemes()
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Enum.reduce(%{numbers: [], symbols: [], temp_value: "", temp_coords: []},
        fn
          {x, "*" = grapheme}, acc ->
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

  defp get_adjacent_numbers({x, y}, numbers_map) do
    adjacent_coords = [
      {x - 1, y - 1},
      {x - 1, y},
      {x, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x, y + 1},
      {x + 1, y + 1}
    ]

    adjacent_coords
    |> Enum.filter(fn coord -> Map.has_key?(numbers_map, coord) end)
    |> Enum.map(fn coord -> numbers_map[coord] end)
    |> Enum.uniq()
    |> Enum.map(fn number -> number.value end)
  end
end
