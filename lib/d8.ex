defmodule D8 do
  def p1(file) do
    {lr, lines} = parse_file(file)
    traverse(lr, lr, lines, "AAA", 0)
  end

  defp parse_file(file) do
    [lr | lines] =
      file
      |> File.read!()
      |> String.split(["\n"], trim: true)

    lines =
      lines
      |> Enum.map(fn line ->
        line
        |> String.split(["=", "(", ")", ",", " "], trim: true)
        |> List.to_tuple()
      end)

    lr = to_charlist(lr)

    {lr, lines}
  end

  defp traverse(_, _, _, "ZZZ", steps) do
    steps
  end

  defp traverse(lr, [], lines, current, steps) do
    traverse(lr, lr, lines, current, steps)
  end

  defp traverse(lr, [dir | dirs], lines, current, steps) do
    {^current, left, right} = List.keyfind(lines, current, 0)

    case dir do
      ?L -> traverse(lr, dirs, lines, left, steps + 1)
      ?R -> traverse(lr, dirs, lines, right, steps + 1)
    end
  end

  def p2(file) do
    {lr, lines} = parse_file(file)

    lines
    |> Enum.map(fn {current, _, _} -> current end)
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(fn start -> traverse_p2(lr, lr, lines, start, 0) end)
    |> lcm()
  end

  defp traverse_p2(_, _, _, <<_, _, ?Z>>, steps) do
    steps
  end

  defp traverse_p2(lr, [], lines, current, steps) do
    traverse_p2(lr, lr, lines, current, steps)
  end

  defp traverse_p2(lr, [dir | dirs], lines, current, steps) do
    {^current, left, right} = List.keyfind(lines, current, 0)

    case dir do
      ?L -> traverse_p2(lr, dirs, lines, left, steps + 1)
      ?R -> traverse_p2(lr, dirs, lines, right, steps + 1)
    end
  end

  defp lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end

  defp lcm(list) do
    Enum.reduce(list, &lcm(&2, &1))
  end
end
