defmodule FetchTest do
  use ExUnit.Case, async: true

  setup do
    bypass = Bypass.open
    {:ok, bypass: bypass}
  end

  test "response is valid json", %{bypass: bypass} do
    request_path = "/api/listings"
    Bypass.expect bypass, fn conn ->
      assert request_path == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, "{\"listings\": []}")
    end
    url = endpoint_url(bypass.port, request_path)
    fetch = MultiApi.Fetch.fetch([url])
    assert [%{url: url, response: %{"listings" => []}}] == fetch
  end

  test "response is invalid json", %{bypass: bypass} do
    request_path = "/api/listings"
    Bypass.expect bypass, fn conn ->
      assert request_path == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, "{\"listings\": []")
    end
    url = endpoint_url(bypass.port, request_path)
    fetch = MultiApi.Fetch.fetch([url])
    assert [%{url: url, response: "{\"listings\": []"}] == fetch
  end

  test "with bad request" do
    fetch = MultiApi.Fetch.fetch("bad request")
    assert %{error: "Invalid argument"} == fetch
  end

  defp endpoint_url(port, path), do: "http://localhost:#{port}#{path}"
end
