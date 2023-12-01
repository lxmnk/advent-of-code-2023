defmodule Solution do
  @calibration_number_regex ~r/(?=(\d{1}|one|two|three|four|five|six|seven|eight|nine)(\d{1}|one|two|three|four|five|six|seven|eight|nine)?)/

  def execute do
    File.stream!("input.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&find_calibration_value/1)
    |> Enum.reduce(0, fn value, acc -> value + acc end)
    |> IO.puts()
  end

  defp find_calibration_value(line) do
    value = find_head(line) <> find_tail(line)

    String.to_integer(value)
  end

  defp find_head(line) do
    @calibration_number_regex
    |> Regex.run(line)
    |> Enum.at(1)
    |> maybe_convert_value()
  end

  defp find_tail(line) do
    @calibration_number_regex
    |> Regex.scan(line)
    |> List.last()
    |> Enum.at(1)
    |> maybe_convert_value()
  end

  defp maybe_convert_value(value)
      when value in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  do
    value
  end
  defp maybe_convert_value(value) do
    case value do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
    end
  end
end
