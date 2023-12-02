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
      digit(line) * 10 + digit(String.reverse(line))
    end)
    |> Enum.sum()
  end

  def digit("one" <> _), do: 1
  def digit("two" <> _), do: 2
  def digit("three" <> _), do: 3
  def digit("four" <> _), do: 4
  def digit("five" <> _), do: 5
  def digit("six" <> _), do: 6
  def digit("seven" <> _), do: 7
  def digit("eight" <> _), do: 8
  def digit("nine" <> _), do: 9
  def digit("zero" <> _), do: 0
  def digit("eno" <> _), do: 1
  def digit("owt" <> _), do: 2
  def digit("eerht" <> _), do: 3
  def digit("ruof" <> _), do: 4
  def digit("evif" <> _), do: 5
  def digit("xis" <> _), do: 6
  def digit("neves" <> _), do: 7
  def digit("thgie" <> _), do: 8
  def digit("enin" <> _), do: 9
  def digit("orez" <> _), do: 0
  def digit("0" <> _), do: 0
  def digit("1" <> _), do: 1
  def digit("2" <> _), do: 2
  def digit("3" <> _), do: 3
  def digit("4" <> _), do: 4
  def digit("5" <> _), do: 5
  def digit("6" <> _), do: 6
  def digit("7" <> _), do: 7
  def digit("8" <> _), do: 8
  def digit("9" <> _), do: 9
  def digit(<<_, s::binary>>), do: digit(s)
end
