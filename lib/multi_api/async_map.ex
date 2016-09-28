defmodule MultiApi.AsyncMap do
  def async_map(list, async) do
    list |>
    Enum.map(&async_single(&1, async)) |>
    length() |>
    stream_responses()
  end

  defp async_single(item, async) do
    pid = self()
    Task.start_link(fn -> send(pid, async.(item)) end)
    item
  end

  defp stream_responses(count) do
    Stream.resource(
      fn -> 0 end,
      fn (processed) ->
        if processed >= count do
          {:halt, processed}
        else
          receive do
            response -> {[response], processed + 1}
          end
        end
      end,
      fn (values) -> values end
    )
  end
end
