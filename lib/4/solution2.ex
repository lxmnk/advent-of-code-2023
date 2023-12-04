defmodule AdventOfCode.Day4.Solution2 do
  defmodule Card do
    defstruct id: nil, winning_numbers: [], actual_numbers: []

    def matching_numbers_count(%Card{} = card) do
      card.actual_numbers
      |> Enum.filter(fn number ->
        number in card.winning_numbers
      end)
      |> length()
    end
  end

  def execute do
    File.stream!("priv/4.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&build_cards/1)
    |> count_won_cards()
    |> Enum.reduce(0, fn {_, count}, acc -> acc + count end)
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

  defp count_won_cards(cards) do
    copies_map =
      1..length(cards)
      |> Enum.map(fn id -> {id, 1} end)
      |> Enum.into(%{})

    cards
    |> Enum.map(fn card -> {card.id, Card.matching_numbers_count(card)} end)
    |> Enum.reduce(copies_map, fn {card_id, matching_numbers_count}, acc ->
      range =
        (card_id + 1)..(card_id + 1 + matching_numbers_count)
        |> Enum.to_list()
        |> List.delete_at(-1)

      Enum.reduce(range, acc, fn id, acc ->
        Map.update!(acc, id, fn copies -> copies + acc[card_id] end)
      end)
    end)
  end
end
