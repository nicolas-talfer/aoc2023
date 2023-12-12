defmodule D10 do
  defmodule Cell, do: defstruct([:x, :y, :char, in_loop: false])

  def p1(), do: p1("lib/d10_example.txt")

  def p1(file) do
    {start_pos, map, _, _} = build_map(file)

    [pos1, pos2] = get_first_2_pos(start_pos, map)

    {_map, steps} = travel(map, start_pos, map[pos1], start_pos, map[pos2], 1)

    steps
  end

  def add_in_loop(map, pos) do
    cell = map[pos]
    cell = %Cell{cell | in_loop: true}
    Map.put(map, pos, cell)
  end

  defp travel(map, _, %Cell{x: x, y: y}, _, %Cell{x: x, y: y}, steps) do
    map = add_in_loop(map, {x, y})
    {map, steps}
  end

  defp travel(map, from1, cell1, from2, cell2, steps) do
    map = add_in_loop(map, from1)
    map = add_in_loop(map, from2)
    next_cell1 = map[next_pos(from1, cell1)]
    next_cell2 = map[next_pos(from2, cell2)]
    travel(map, {cell1.x, cell1.y}, next_cell1, {cell2.x, cell2.y}, next_cell2, steps + 1)
  end

  defp next_pos({_from_x, from_y}, %Cell{x: x, y: y, char: "|"}) do
    if from_y < y do
      {x, y + 1}
    else
      {x, y - 1}
    end
  end

  defp next_pos({from_x, _from_y}, %Cell{x: x, y: y, char: "-"}) do
    if from_x < x do
      {x + 1, y}
    else
      {x - 1, y}
    end
  end

  defp next_pos({_from_x, from_y}, %Cell{x: x, y: y, char: "F"}) do
    if from_y > y do
      {x + 1, y}
    else
      {x, y + 1}
    end
  end

  defp next_pos({from_x, _from_y}, %Cell{x: x, y: y, char: "J"}) do
    if from_x < x do
      {x, y - 1}
    else
      {x - 1, y}
    end
  end

  defp next_pos({from_x, _from_y}, %Cell{x: x, y: y, char: "7"}) do
    if from_x < x do
      {x, y + 1}
    else
      {x - 1, y}
    end
  end

  defp next_pos({from_x, _from_y}, %Cell{x: x, y: y, char: "L"}) do
    if from_x == x do
      {x + 1, y}
    else
      {x, y - 1}
    end
  end

  defp get_first_2_pos({x_s, y_s}, map) do
    case map[{x_s, y_s - 1}] do
      c when c.char in ["|", "7", "F"] -> [{x_s, y_s - 1}]
      _ -> []
    end ++
      case map[{x_s, y_s + 1}] do
        c when c.char in ["|", "L", "J"] -> [{x_s, y_s + 1}]
        _ -> []
      end ++
      case map[{x_s - 1, y_s}] do
        c when c.char in ["-", "F", "L"] -> [{x_s - 1, y_s}]
        _ -> []
      end ++
      case map[{x_s + 1, y_s}] do
        c when c.char in ["-", "7", "J"] -> [{x_s + 1, y_s}]
        _ -> []
      end
  end

  defp build_map(file) do
    str = File.read!(file)

    index =
      str
      |> to_charlist()
      |> Enum.find_index(&(&1 == ?S))

    lines = String.split(str, "\n")

    width = lines |> Enum.at(0) |> String.length()
    height = lines |> Enum.count()

    x_s = rem(index, width + 1)
    y_s = div(index, height + 1)

    map =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc1 ->
        line
        |> to_charlist()
        |> Enum.with_index()
        |> Enum.reduce(acc1, fn {char, x}, acc2 ->
          in_loop = x == x_s and y == y_s
          Map.put(acc2, {x, y}, %Cell{x: x, y: y, char: <<char>>, in_loop: in_loop})
        end)
      end)

    {{x_s, y_s}, map, width, height}
  end

  def p2(), do: p2("lib/d10_example.txt")

  def p2(file) do
    {start_pos, map, width, height} = build_map(file)

    [{x1, y1} = pos1, {x2, y2} = pos2] = get_first_2_pos(start_pos, map)

    char_s =
      cond do
        x1 == x2 -> "|"
        y1 == y2 -> "-"
        x1 < x2 and y1 > y2 -> "F"
        x2 < x1 and y2 > y1 -> "F"
        x1 < x2 and y1 > y2 -> "J"
        x2 < x1 and y2 > y1 -> "J"
        x1 < x2 and y1 < y2 -> "L"
        x2 < x1 and y2 < y1 -> "L"
        x1 < x2 and y1 < y2 -> "7"
        x2 < x1 and y2 < y1 -> "7"
      end

    cell_s = map[start_pos]
    cell_s = %Cell{cell_s | char: char_s}
    map = Map.put(map, start_pos, cell_s)

    {map, _steps} = travel(map, start_pos, map[pos1], start_pos, map[pos2], 1)

    map = clean_map(map, width, height)
    map = extend_map_horizontally(map, width, height)
    map = extend_map_vertically(map, width, height)
    _map = flood(map, width, height)
  end

  defp clean_map(map, width, height) do
    0..(height - 1)
    |> Enum.reduce(map, fn y, acc1 ->
      0..(width - 1)
      |> Enum.reduce(acc1, fn x, acc2 ->
        cell = map[{x, y}]

        case cell.in_loop do
          true -> acc2
          false -> Map.put(acc2, {x, y}, %Cell{char: "."})
        end
      end)
    end)
  end

  defp extend_map_horizontally(map, width, height) do
    0..(height - 1)
    |> Enum.reduce(map, fn y, acc1 ->
      0..(width - 2)
      |> Enum.reduce(acc1, fn x, acc2 ->
        char1 = map[{x, y}].char
        char2 = map[{x + 1, y}].char

        middle_char =
          cond do
            char1 in ["-", "F", "L"] and char2 in ["-", "7", "J"] -> "-"
            true -> "."
          end

        Map.put(acc2, {x + 0.5, y}, %Cell{x: x + 0.5, y: y, char: middle_char, in_loop: true})
      end)
    end)
  end

  defp extend_map_vertically(map, width, height) do
    0..(width - 1)
    |> Enum.reduce(map, fn x, acc1 ->
      0..(height - 2)
      |> Enum.reduce(acc1, fn y, acc2 ->
        char1 = map[{x, y}].char
        char2 = map[{x, y + 1}].char

        middle_char =
          cond do
            char1 in ["|", "F", "7"] and char2 in ["|", "L", "J"] -> "|"
            true -> "."
          end

        Map.put(acc2, {x, y + 0.5}, %Cell{x: x, y: y + 0.5, char: middle_char, in_loop: true})
      end)
    end)
  end

  defp flood(map, width, height) do
    Process.put(:flooded, 0)
    do_flood(map, width, height)

    case Process.get(:flooded) do
      0 -> :ok
      _ -> flood(map, width, height)
    end
  end

  defp incr() do
    v = Process.get(:flooded)
    Process.put(:flooded, v + 1)
  end

  defp do_flood(map, width, height) do
    0..(height - 1)
    |> Enum.reduce(map, fn y, acc1 ->
      0..(width - 1)
      |> Enum.reduce(acc1, fn x, acc2 ->
        cell = map[{x, y}]

        cond do
          cell.in_loop ->
            acc2

          cell.char == "O" ->
            acc2

          x == 0 or x == width - 1 or y == 0 or y == height - 1 ->
            incr()
            Map.put(acc2, {x, y}, %Cell{cell | char: "0"})

          map[{x - 1, y}] == "0" ->
            incr()
            Map.put(acc2, {x, y}, %Cell{cell | char: "0"})

          map[{x + 1, y}] == "0" ->
            incr()
            Map.put(acc2, {x, y}, %Cell{cell | char: "0"})

          map[{x, y - 1}] == "0" ->
            incr()
            Map.put(acc2, {x, y}, %Cell{cell | char: "0"})

          map[{x, y + 1}] == "0" ->
            incr()
            Map.put(acc2, {x, y}, %Cell{cell | char: "0"})

          true ->
            IO.inspect cell
            acc2
        end
      end)
    end)
  end
end
