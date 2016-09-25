defmodule AsyncMapTest do
  use ExUnit.Case, async: true

  test "it functions like regular map" do
    async = fn (item) -> { item, "hello" } end
    list = ["one", "two"]

    regular_map = list |>
    Enum.map(async)

    assert MultiApi.AsyncMap.async_map(list, async) == regular_map
  end
end
