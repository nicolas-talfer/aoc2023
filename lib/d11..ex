defmodule D11 do
  @factor 1_000_000

  def solve(file) do
    str =
      file
      |> File.read!()

    lines =
      str
      |> String.split("\n")
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.reduce([], &expand_rows_or_columns/2)
      |> Enum.reverse()

    width = Enum.count(Enum.at(lines, 0))
    height = Enum.count(lines)

    columns =
      build_columns(lines, height, width)
      |> Enum.reduce([], &expand_rows_or_columns/2)
      |> Enum.reverse()

    column_size = Enum.count(Enum.at(columns, 0))
    column_count = Enum.count(columns)

    galaxies = galaxies(columns, column_size, column_count)

    do_solve(galaxies, columns, 0)
  end

  defp do_solve([_], _, sum) do
    sum
  end

  defp do_solve([{x, y} | galaxies], columns, sum) do
    new_sum =
      galaxies
      |> Enum.reduce(sum, fn {gx, gy}, acc1 ->
        size_x =
          if gx == x do
            0
          else
            (min(x, gx) + 1)..max(x, gx)
            |> Enum.reduce(0, fn ix, accx ->
              char = Enum.at(columns, ix) |> Enum.at(y)

              case char do
                _ when is_binary(char) -> accx + 1
                _ when is_integer(char) -> accx + char
              end
            end)
          end

        size_y =
          if gy == y do
            0
          else
            (min(y, gy) + 1)..max(y, gy)
            |> Enum.reduce(0, fn iy, accy ->
              char = Enum.at(columns, x) |> Enum.at(iy)

              case char do
                _ when is_binary(char) -> accy + 1
                _ when is_integer(char) -> accy + char
              end
            end)
          end

        acc1 + size_x + size_y
      end)

    do_solve(galaxies, columns, new_sum)
  end

  defp build_columns(lines, height, width) do
    0..(width - 1)
    |> Enum.reduce([], fn x, acc ->
      column =
        0..(height - 1)
        |> Enum.map(fn y ->
          Enum.at(lines, y) |> Enum.at(x)
        end)

      [column | acc]
    end)
    |> Enum.reverse()
  end

  defp expand_rows_or_columns(row_or_col, acc) do
    case Enum.all?(row_or_col, &(&1 == "." or is_integer(&1))) do
      true ->
        l = List.duplicate(@factor, Enum.count(row_or_col))
        [l | acc]

      false ->
        [row_or_col | acc]
    end
  end

  defp galaxies(columns, column_size, column_count) do
    0..(column_count - 1)
    |> Enum.reduce([], fn x, acc1 ->
      0..column_size
      |> Enum.reduce(acc1, fn y, acc2 ->
        char = Enum.at(columns, x) |> Enum.at(y)

        case char do
          "#" -> [{x, y} | acc2]
          _ -> acc2
        end
      end)
    end)
  end
end
