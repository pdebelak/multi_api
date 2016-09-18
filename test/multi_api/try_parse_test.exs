defmodule TryParseTest do
  use ExUnit.Case, async: true

  test "with valid json it parses" do
    json = "{\"hello\":\"goodbye\"}"
    assert MultiApi.TryParse.parse(json) == %{ "hello" => "goodbye" }
  end

  test "with invalid json it doesn't parse" do
    json = "{\"hello\":\"goodbye\""
    assert MultiApi.TryParse.parse(json) == json
  end
end
