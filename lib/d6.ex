defmodule D6 do
  def p1(file) do
    races =
      file
      |> File.read!()
      |> String.split(["Time:", "Distance:"], trim: true)
      |> Enum.map(fn data ->
        data
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.zip

    races
    |> Enum.map(&beats/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  defp beats({duration, record}) do
    1..duration-1
    |> Enum.map(fn h -> {h, distance(h, duration)} end)
    |> Enum.filter(fn {_, d} -> d > record end)
  end

  def distance(hold_time, duration) do
    (duration - hold_time) * hold_time
  end

  def p2(file) do
    [duration, record] =
      file
      |> File.read!()
      |> String.split(["Time:", "Distance:", "\n"], trim: true)
      |> Enum.map(&(String.replace(&1, " ", "")))
      |> Enum.map(&String.to_integer/1)

    # équation: x² - duration * x + record = 0
    # tous les x entre les 2 solutions
    a = 1
    b = - duration
    c = record

    delta = b**2 - 4 * a * c

    x1 = round(:math.ceil((-b - :math.sqrt(delta)) / (2 * a)))
    x2 = round(:math.floor((-b + :math.sqrt(delta)) / (2 * a)))

    x2 - x1 + 1
  end
end
