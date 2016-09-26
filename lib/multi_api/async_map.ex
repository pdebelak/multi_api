defmodule MultiApi.AsyncMap do
  def async_map(list, async) do
    list |>
    Enum.map(fn (item) ->
      async_single(item, async)
      item
    end) |>
    length() |>
    stream_responses()
  end

  defp async_single(item, async) do
    pid = self()
    spawn_link(fn -> send(pid, async.(item)) end)
  end

  defp stream_responses(count) do
    Stream.resource(
      fn -> [] end,
      fn (values) ->
        if length(values) >= count do
          {:halt, values}
        else
          receive do
            response -> receive_response(response, values)
          end
        end
      end,
      fn (values) -> values end
    )
  end

  defp receive_response(response, values) do
    {[response], values ++ [response]}
  end
end
