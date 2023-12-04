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
    ["Game " <> id | sets] = String.split(game, [":", ";"])

    parsed_sets =
      sets
      |> Enum.map(fn set ->
        ["red", "blue", "green"]
        |> Enum.map(fn color ->
          case Regex.named_captures(~r/(?<#{color}>[0-9]*) #{color}/, set) do
            nil -> 0
            %{^color => count} -> String.to_integer(count)
          end
        end)
        |> List.to_tuple()
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
