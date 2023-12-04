defmodule D4 do
  def p1(file) do
    file
    |> scratchcards()
    |> Enum.map(fn {_, matching} -> matching end)
    |> points()
    |> Enum.sum()
  end

  defp scratchcards(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      ["Card" <> id, winning, having] = String.split(line, [":", "|"])
      id = id |> String.trim() |> String.to_integer()
      winning = String.split(winning)

      matching =
        having
        |> String.split()
        |> Enum.filter(&Enum.member?(winning, &1))

      {id, matching}
    end)
  end

  defp points([]), do: 0

  defp points(numbers) do
    n = Enum.count(numbers)
    :math.pow(2, n - 1) |> :erlang.round()
  end

  def p2(file) do
    file
    |> scratchcards()
    |> Enum.reduce(%{}, fn {id, _} = scratchcard, acc ->
      id_count = Map.get(acc, id, 0) + 1
      acc = Map.put(acc, id, id_count)
      copies = copies(scratchcard)

      Enum.reduce(copies, acc, fn copy_id, acc2 ->
        copy_id_count = Map.get(acc2, copy_id, 0)
        Map.put(acc2, copy_id, copy_id_count + id_count)
      end)
    end)
    |> Enum.map(fn {_, count} -> count end)
    |> Enum.sum()
  end

  defp copies({_, []}), do: []

  defp copies({id, matching}) do
    (id + 1)..(id + Enum.count(matching)) |> Enum.to_list()
  end
end
