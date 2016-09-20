defmodule RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts MultiApi.Router.init([])

  test "get to root path is usage instructions as application/json" do
    conn = conn(:get, "/")
    |> put_req_header("content-type", "application/json")
    |> MultiApi.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Regex.match?(~r/usage/i, Poison.decode!(conn.resp_body))
  end

  test "get to root path is home page for other content types" do
    conn = conn(:get, "/")
    |> MultiApi.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Regex.match?(~r/welcome/i, conn.resp_body)
  end

  test "get to other path is 404" do
    conn = conn(:get, "/path")
    |> MultiApi.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert Poison.decode!(conn.resp_body) == %{"error" => "Not found"}
  end

  test "post to non-root path is 404" do
    conn = conn(:post, "/path")
    |> MultiApi.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert Poison.decode!(conn.resp_body) == %{"error" => "Not found"}
  end

  test "json post to root path is successful" do
    conn = conn(:post, "/", "{\"urls\":[]}")
    |> put_req_header("content-type", "application/json")
    |> MultiApi.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Poison.decode!(conn.resp_body) == []
  end
end
