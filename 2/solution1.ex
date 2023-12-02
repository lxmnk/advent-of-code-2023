defmodule Solution1 do
  @round_regex ~r/(\d+)\ (red|green|blue)/

  @max_red_cubes 12
  @max_green_cubes 13
  @max_blue_cubes 14

  defmodule Game do
    defstruct id: nil, rounds: nil
  end

  def execute do
    File.stream!("input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&build_game/1)
    |> Enum.reduce(0, fn game, acc ->
      if game_possible?(game) do
        acc + game.id
      else
        acc
      end
    end)
    |> IO.puts()
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

  defp game_possible?(%Game{rounds: rounds}) do
    rounds
    |> Enum.map(&round_possible?/1)
    |> Enum.all?()
  end

  defp round_possible?(round) do
    round["red"] <= @max_red_cubes
      and round["green"] <= @max_green_cubes
      and round["blue"] <= @max_blue_cubes
  end
end
