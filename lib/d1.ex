defmodule D1 do
  def p1(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      str = Regex.scan(~r/[0-9]*/, line) |> to_string()
      String.to_integer(String.at(str, 0)) * 10 + String.to_integer(String.at(str, -1))
    end)
    |> Enum.sum()
  end

  def p2(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      ldigit(line) * 10 + rdigit(String.reverse(line))
    end)
    |> Enum.sum()
  end

  defp ldigit("one" <> _), do: 1
  defp ldigit("two" <> _), do: 2
  defp ldigit("three" <> _), do: 3
  defp ldigit("four" <> _), do: 4
  defp ldigit("five" <> _), do: 5
  defp ldigit("six" <> _), do: 6
  defp ldigit("seven" <> _), do: 7
  defp ldigit("eight" <> _), do: 8
  defp ldigit("nine" <> _), do: 9
  defp ldigit("zero" <> _), do: 0
  defp ldigit(<<c>> <> _) when c >= ?0 and c <= ?9, do: c - ?0
  defp ldigit(<<_, s::binary>>), do: ldigit(s)

  defp rdigit("eno" <> _), do: 1
  defp rdigit("owt" <> _), do: 2
  defp rdigit("eerht" <> _), do: 3
  defp rdigit("ruof" <> _), do: 4
  defp rdigit("evif" <> _), do: 5
  defp rdigit("xis" <> _), do: 6
  defp rdigit("neves" <> _), do: 7
  defp rdigit("thgie" <> _), do: 8
  defp rdigit("enin" <> _), do: 9
  defp rdigit("orez" <> _), do: 0
  defp rdigit(<<c>> <> _) when c >= ?0 and c <= ?9, do: c - ?0
  defp rdigit(<<_, s::binary>>), do: rdigit(s)
end
