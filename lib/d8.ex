defmodule D8 do
  def p1(file) do
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

    steps = 0

    traverse(lr, lr, lines, "AAA", steps)
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
      ?L -> traverse(lr, dirs, lines, left, steps+1)
      ?R -> traverse(lr, dirs, lines, right, steps+1)
    end
  end
end
