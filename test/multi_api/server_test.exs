defmodule ServerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "get to root path is 404" do
    conn = conn(:get, "/")
    |> MultiApi.Server.call([])

    assert conn.state == :sent
    assert conn.status == 404
    assert Poison.decode!(conn.resp_body) == %{"error" => "Not found"}
  end

  test "get to other path is 404" do
    conn = conn(:get, "/path")
    |> MultiApi.Server.call([])

    assert conn.state == :sent
    assert conn.status == 404
    assert Poison.decode!(conn.resp_body) == %{"error" => "Not found"}
  end

  test "post to non-root path is 404" do
    conn = conn(:post, "/path")
    |> MultiApi.Server.call([])

    assert conn.state == :sent
    assert conn.status == 404
    assert Poison.decode!(conn.resp_body) == %{"error" => "Not found"}
  end

  test "post to root path is successful" do
    conn = conn(:post, "/", "[]")
    |> MultiApi.Server.call([])

    assert conn.state == :sent
    assert conn.status == 200
    assert Poison.decode!(conn.resp_body) == []
  end
end
