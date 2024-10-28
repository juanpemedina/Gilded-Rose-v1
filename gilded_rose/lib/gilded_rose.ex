defmodule GildedRose do
  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  defp decrease_quality(%{quality: quality, name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp decrease_quality(%{quality: quality} = item) when quality > 0, do: %{item | quality: quality - 1}
  defp decrease_quality(item), do: item

  defp increase_quality(%{quality: quality} = item) when quality < 50 do
    %{item | quality: quality + 1}
  end
  defp increase_quality(item), do: item

  defp update_backstage_pass_quality(item) do
    item
    |> increase_quality()
    |> (fn item ->
          if item.sell_in < 11, do: increase_quality(item), else: item
        end).()
    |> (fn item ->
          if item.sell_in < 6, do: increase_quality(item), else: item
        end).()
  end

  def update_item(item) do
    item = cond do
      item.name == "Aged Brie" ->
        increase_quality(item)
        
      item.name == "Backstage passes to a TAFKAL80ETC concert" ->
        update_backstage_pass_quality(item)
      
      item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
        decrease_quality(item)
        
      true -> item
    end
    
    item = cond do
      item.name != "Sulfuras, Hand of Ragnaros" ->
        %{item | sell_in: item.sell_in - 1}
      true -> item
    end
    
    cond do
      item.sell_in < 0 ->
        cond do
          item.name != "Aged Brie" ->
            cond do
              item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                cond do
                  item.quality > 0 ->
                    cond do
                      item.name != "Sulfuras, Hand of Ragnaros" ->
                        %{item | quality: item.quality - 1}
                      true -> item
                    end
                  true -> item
                end
              true -> %{item | quality: item.quality - item.quality}
            end
          true ->
            cond do
              item.quality < 50 ->
                %{item | quality: item.quality + 1}
              true -> item
            end
        end
      true -> item
    end
  end
end
