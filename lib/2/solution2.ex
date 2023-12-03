defmodule AdventOfCode.Day2.Solution2 do
  @round_regex ~r/(\d+)\ (red|green|blue)/

  defmodule Game do
    defstruct id: nil, rounds: nil
  end

  def execute do
    File.stream!("priv/2.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&build_game/1)
    |> Enum.reduce(0, fn game, acc ->
      %{
        "red" => red,
        "green" => green,
        "blue" => blue
      } = find_min_cubes_count(game)

      acc + (red * green * blue)
    end)
  end

  defp build_game(line) do
    ["Game " <> raw_id, raw_rounds] = String.split(line, ": ")

    id = String.to_integer(raw_id)

    rounds =
      raw_rounds
      |> String.split(";")
      |> Enum.map(fn raw_round ->
        @round_regex
        |> Regex.scan(raw_round)
        |> Enum.reduce(
          %{"red" => 0, "green" => 0, "blue" => 0},
          fn [_, count, color], acc ->
            Map.put(acc, color, String.to_integer(count))
          end
        )
      end)

    %Game{id: id, rounds: rounds}
  end

  defp find_min_cubes_count(%Game{rounds: rounds}) do
    Enum.reduce(
      rounds,
      %{"red" => 0, "green" => 0, "blue" => 0},
      fn %{"red" => red, "green" => green, "blue" => blue}, acc ->
        %{
          "red" => Enum.max([acc["red"], red]),
          "green" => Enum.max([acc["green"], green]),
          "blue" => Enum.max([acc["blue"], blue])
        }
      end
    )
  end
end
