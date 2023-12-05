defmodule D5 do
  def p1(file) do
    ["seeds: " <> seeds | maps] =
      file
      |> File.read!()
      |> String.split([
        "seed-to-soil map:",
        "soil-to-fertilizer map:",
        "fertilizer-to-water map:",
        "water-to-light map:",
        "light-to-temperature map:",
        "temperature-to-humidity map:",
        "humidity-to-location map:"
      ])

    seeds = seeds |> String.split() |> Enum.map(&String.to_integer/1)
    maps =
      Enum.map(maps, fn map ->
        map
        |> String.split("\n", trim: true)
        |> Enum.map(fn line ->
          line
          |> String.split()
          |> Enum.map(&String.to_integer/1)
        end)
      end)

    seeds
    |> Enum.map(&seed_location(&1, maps))
    |> Enum.min()
  end

  defp seed_location(seed, maps) do
    Enum.reduce(maps, seed, &source_to_dest/2)
  end

  defp source_to_dest([], source) do
    source
  end

  defp source_to_dest([[dest_start, source_start, range_length] | _], source)
       when source >= source_start and source <= source_start + range_length do
    dest_start + source - source_start
  end

  defp source_to_dest([_ | lines], source) do
    source_to_dest(lines, source)
  end
end
