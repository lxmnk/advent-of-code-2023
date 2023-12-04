defmodule AdventOfCode.Day4.Solution1 do
  defmodule Card do
    defstruct id: nil, winning_numbers: [], actual_numbers: []
  end

  def execute do
    File.stream!("priv/4.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&build_cards/1)
    |> sum_card_points()
  end

  def build_cards(line) do
    ["Card " <> id_str, numbers_str] = String.split(line, ":")

    [winning_numbers, actual_numbers] =
      numbers_str
      |> String.split("|")
      |> Enum.map(fn str ->
        str |> String.split() |> Enum.map(&String.to_integer/1)
      end)

    %Card{
      id: id_str |> String.trim() |> String.to_integer(),
      winning_numbers: winning_numbers,
      actual_numbers: actual_numbers
    }
  end

  defp sum_card_points(cards) do
    cards
    |> Enum.map(fn card ->
      card.actual_numbers
      |> Enum.filter(fn number ->
        number in card.winning_numbers
      end)
      |> length()
      |> case do
           0 -> 0
           1 -> 1
           length -> 2 ** (length - 1)
         end
    end)
    |> Enum.reduce(0, &+/2)
  end
end
