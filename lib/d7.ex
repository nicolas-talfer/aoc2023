defmodule D7 do
  #def p1(file) do
    def p2(file) do
    hbs =
      file
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.map(&format_hand_bid/1)
      |> Enum.sort(&compare_hbs/2)
      |> Enum.with_index(fn hb, index -> %{hb | rank: index+1} end)

    Enum.reduce(hbs, 0, fn %{rank: rank, bid: bid}, acc -> acc + rank * bid end)
  end

  defp format_hand_bid([hand, bid]) do
    %{hand: hand, type: type(hand), bid: String.to_integer(bid), rank: nil}
  end

  @five_of_a_kind 6
  @four_of_a_kind 5
  @full_house 4
  @three_of_a_kind 3
  @two_pairs 2
  @one_pair 1
  @high_hand 0

  defp type(hand) do
    hand
    |> to_charlist()
    |> Enum.frequencies()
    |> Enum.sort_by(fn {_, f} -> f end)
    |> Enum.reverse()
    |> get_type
  end

  defp get_type([{_, 5}]) do
    @five_of_a_kind
  end
#################
  defp get_type([{_, 4}, {?J, _}]) do
    @five_of_a_kind
  end

  defp get_type([{?J, 4}, _]) do
    @five_of_a_kind
  end

  defp get_type([{_, 4}, _]) do
    @four_of_a_kind
  end
#############
  defp get_type([{_, 3}, {?J, 2}]) do
    @five_of_a_kind
  end

  defp get_type([{?J, 3}, {_, 2}]) do
    @five_of_a_kind
  end

  defp get_type([{?J, 3}, _, _]) do
    @four_of_a_kind
  end

  defp get_type([{_, 3}, {_, 2}]) do
    @full_house
  end

  defp get_type([{_, 3}, {letter1, 1}, {letter2, 1}]) when letter1 == ?J or letter2 == ?J do
    @four_of_a_kind
  end

  defp get_type([{_, 3}, _, _]) do
    @three_of_a_kind
  end
################
  defp get_type([{_, 2}, {_, 2}, {?J, 1}]) do
    @full_house
  end

  defp get_type([{letter1, 2}, {letter2, 2}, _]) when letter1 == ?J or letter2 == ?J do
    @four_of_a_kind
  end

  defp get_type([{?J, 2}, _, _, _]) do
    @three_of_a_kind
  end

  defp get_type([{_, 2}, {_, 2}, _]) do
    @two_pairs
  end

  defp get_type([{_, 2}, {letter1, 1}, {letter2, 1}, {letter3, 1}]) when letter1 == ?J or letter2 == ?J or letter3 == ?J do
    @three_of_a_kind
  end

  defp get_type([{_, 2}, _, _, _]) do
    @one_pair
  end

  defp get_type([{l1, 1}, {l2, 1}, {l3, 1}, {l4, 1}, {l5, 1}]) do

    case Enum.any?([l1,l2,l3,l4,l5] , fn l -> l == ?J end) do
      true ->
        @one_pair
      false ->
        @high_hand
    end
  end

  # defp get_type(hand) do
  #   @high_hand
  # end

  def compare_hbs(%{type: type1, hand: hand1}, %{type: type2, hand: hand2}) do
    case type1 == type2 do
      true ->
        compare_hands(to_charlist(hand1), to_charlist(hand2))
      _ ->
        type1 < type2
    end
  end

  def compare_hands([h | rest1], [h | rest2])  do
    compare_hands(rest1, rest2)
  end
  def compare_hands([h1 | _], [h2 | _]) do
    strength(h1) < strength(h2)
  end

  defp strength(x) when x >= ?2 and x <= ?9, do: x
  defp strength(?A), do: 300
  defp strength(?K), do: 299
  defp strength(?Q), do: 298
  defp strength(?J), do: 0 #297
  defp strength(?T), do: 296
end
