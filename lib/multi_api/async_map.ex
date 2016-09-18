defmodule MultiApi.AsyncMap do
  def async_map(list, async, await) do
    list |>
    Enum.map(fn (item) -> async_single(item, async) end) |>
    Enum.map(&Task.await/1) |>
    Enum.map(await)
  end

  defp async_single(item, async) do
    Task.async(fn -> async.(item) end)
  end
end
