defmodule D9 do
 # def p1(file) do
    def p2(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&traverse/1)
    |> Enum.sum
  end

  defp traverse(line) do
    traverse(line, [List.first(line)])
    |> Enum.reduce(fn x, acc -> x - acc end)
    #traverse(line, [List.last(line)])
    #|> Enum.reduce(fn x, acc -> x + acc end)
  end

  defp traverse(line, acc) do
    next_line = do_traverse_once(line, [])
    case Enum.all?(next_line, &(&1 == 0)) do
      true ->
        #[List.last(next_line) | acc]
        [List.first(next_line) | acc]
      false ->
        #traverse(next_line, [List.last(next_line) | acc])
        traverse(next_line, [List.first(next_line) | acc])
    end
  end

  defp do_traverse_once([], acc), do: acc
  defp do_traverse_once([_], acc), do: acc
  defp do_traverse_once([a, b | rest], acc) do
    do_traverse_once([b | rest], acc ++ [b - a])
  end
end
