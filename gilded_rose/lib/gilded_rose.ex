defmodule GildedRose do
  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  defp decrease_quality(%{quality: quality} = item) when quality > 0, do: %{item | quality: quality - 1}
  defp decrease_quality(item), do: item

  defp decrease_quality_expired(item) do
    item
    |> decrease_quality()
    |> decrease_quality()
  end

  defp increase_quality(%{quality: quality} = item) when quality < 50, do: %{item | quality: quality + 1}
  defp increase_quality(item), do: item

  defp update_backstage_pass_quality(item) do
    item
    |> increase_quality()
    |> (fn item -> if item.sell_in < 11, do: increase_quality(item), else: item end).()
    |> (fn item -> if item.sell_in < 6, do: increase_quality(item), else: item end).()
  end

  defp handle_expired_item(%{name: "Aged Brie"} = item), do: increase_quality(item)
  defp handle_expired_item(%{name: "Backstage passes to a TAFKAL80ETC concert"} = item), do: %{item | quality: 0}
  defp handle_expired_item(item), do: decrease_quality_expired(item)

  def update_item(%{name: "Sulfuras, Hand of Ragnaros"} = item), do: item

  def update_item(item) do
    item =
      cond do
        item.name == "Aged Brie" -> increase_quality(item)
        item.name == "Backstage passes to a TAFKAL80ETC concert" -> update_backstage_pass_quality(item)
        true -> decrease_quality(item)
      end

    item = if item.name != "Sulfuras, Hand of Ragnaros", do: %{item | sell_in: item.sell_in - 1}, else: item

    if item.sell_in < 0, do: handle_expired_item(item), else: item
  end
end
