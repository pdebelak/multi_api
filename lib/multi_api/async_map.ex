defmodule MultiApi.AsyncMap do
  def async_map(list, async) do
    list |>
    Enum.map(fn (item) -> async_single(item, async) end) |>
    Enum.map(&Task.await/1)
  end

  defp async_single(item, async) do
    Task.async(fn -> async.(item) end)
  end
end
