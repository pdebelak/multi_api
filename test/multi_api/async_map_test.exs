defmodule AsyncMapTest do
  use ExUnit.Case, async: true

  test "it functions like regular map" do
    async = fn (item) -> { item, "hello" } end
    await = fn ({item, "hello" }) -> %{ item => "hello" } end
    list = ["one", "two"]

    regular_map = list |>
    Enum.map(async) |>
    Enum.map(await)

    assert MultiApi.AsyncMap.async_map(list, async, await) == regular_map
  end
end
