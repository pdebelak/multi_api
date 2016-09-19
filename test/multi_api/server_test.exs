defmodule ServerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "get to root path is usage instructions as application/json" do
    conn = conn(:get, "/")
    |> put_req_header("content-type", "application/json")
    |> MultiApi.Server.call([])

    assert conn.state == :sent
    assert conn.status == 200
    assert Regex.match?(~r/usage/i, Poison.decode!(conn.resp_body))
  end

  test "get to root path is home page for other content types" do
    conn = conn(:get, "/")
    |> MultiApi.Server.call([])

    assert conn.state == :sent
    assert conn.status == 200
    assert Regex.match?(~r/welcome/i, conn.resp_body)
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
