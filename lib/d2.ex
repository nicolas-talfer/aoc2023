defmodule D2 do
  def p1(file) do
    games =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&parse_game/1)

    games
    |> Enum.filter(&possible_game?/1)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  defp possible_game?({_, sets}) do
    max_red =
      sets
      |> Enum.map(fn {r, _, _} -> r end)
      |> Enum.max()

    max_blue =
      sets
      |> Enum.map(fn {_, b, _} -> b end)
      |> Enum.max()

    max_green =
      sets
      |> Enum.map(fn {_, _, g} -> g end)
      |> Enum.max()

    max_red <= 12 and max_green <= 13 and max_blue <= 14
  end

  defp parse_game(game) do
    ["Game " <> id, str] = String.split(game, ":")
    sets = String.split(str, ";")

    parsed_sets =
      sets
      |> Enum.map(fn set ->
        red =
          case Regex.named_captures(~r/(?<red>[0-9]*) red/, set) do
            nil -> 0
            c -> String.to_integer(c["red"])
          end

        blue =
          case Regex.named_captures(~r/(?<blue>[0-9]*) blue/, set) do
            nil -> 0
            c -> String.to_integer(c["blue"])
          end

        green =
          case Regex.named_captures(~r/(?<green>[0-9]*) green/, set) do
            nil -> 0
            c -> String.to_integer(c["green"])
          end

        {red, blue, green}
      end)

    {String.to_integer(id), parsed_sets}
  end

  def p2(file) do
    games =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&parse_game/1)

    games
    |> Enum.map(fn {_, sets} -> sets end)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end

  def power(sets) do
    max_red =
      sets
      |> Enum.map(fn {r, _, _} -> r end)
      |> Enum.max()

    max_blue =
      sets
      |> Enum.map(fn {_, b, _} -> b end)
      |> Enum.max()

    max_green =
      sets
      |> Enum.map(fn {_, _, g} -> g end)
      |> Enum.max()

    max_red * max_blue * max_green
  end
end
