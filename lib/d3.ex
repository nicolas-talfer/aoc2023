defmodule D3 do
  def p1(file) do
    lines =
      file
      |> File.read!()
      |> String.split("\n")

    width = Enum.at(lines, 0) |> String.length()
    height = Enum.count(lines)

    numbers =
      Enum.reduce(0..(height - 1), [], fn y, acc ->
        line = Enum.at(lines, y)
        coords = Regex.scan(~r/[0-9]+/, line, return: :index) |> List.flatten()

        x_y_values =
          coords
          |> Enum.map(fn {x, length} ->
            x_max = x + length - 1
            value = String.slice(line, x..x_max) |> String.to_integer()

            {x, y, x_max, value}
          end)

        acc ++ x_y_values
      end)

    numbers
    |> Enum.filter(&has_symbol_around?(lines, width, height, &1))
    |> Enum.map(fn {_, _, _, v} -> v end)
    |> Enum.sum()
  end

  defp has_symbol_around?(lines, width, height, number) do
    has_symbol_left?(lines, width, height, number) or
      has_symbol_right?(lines, width, height, number) or
      has_symbol_up?(lines, width, height, number) or
      has_symbol_down?(lines, width, height, number)
  end

  def has_symbol_left?(_, _, _, {0, _, _, _}) do
    false
  end

  def has_symbol_left?(lines, _, _, {x, y, _, _}) do
    line = Enum.at(lines, y)
    "." != String.at(line, x - 1)
  end

  def has_symbol_right?(_, width, _, {_, _, x_max, _}) when x_max == width - 1 do
    false
  end

  def has_symbol_right?(lines, _, _, {_, y, x_max, _}) do
    line = Enum.at(lines, y)
    "." != String.at(line, x_max + 1)
  end

  def has_symbol_up?(_, _, _, {_, 0, _, _}) do
    false
  end

  def has_symbol_up?(lines, width, _, {x, y, x_max, _}) do
    line = Enum.at(lines, y - 1)
    lx = max(0, x - 1)
    lx_max = min(width - 1, x_max + 1)
    sub_line = String.slice(line, lx..lx_max)
    "" != String.replace(sub_line, ~r/(\.|[0-9])/, "")
  end

  def has_symbol_down?(_, _, height, {_, y, _, _}) when y == height - 1 do
    false
  end

  def has_symbol_down?(lines, width, _, {x, y, x_max, _}) do
    line = Enum.at(lines, y + 1)
    lx = max(0, x - 1)
    lx_max = min(width - 1, x_max + 1)
    sub_line = String.slice(line, lx..lx_max)
    "" != String.replace(sub_line, ~r/(\.|[0-9])/, "")
  end
end
