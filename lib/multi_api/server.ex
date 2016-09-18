defmodule MultiApi.Server do
  import Plug.Conn

  def init(default_opts) do
    IO.puts "starting up MultiApi..."
    default_opts
  end

  def call(conn, _opts) do
    conn |>
    route(conn.method, conn.path_info)
  end

  defp route(conn, "POST", []) do
    conn |>
    respond(200, MultiApi.Fetch.fetch(body(conn)))
  end

  defp route(conn, _, _) do
    conn |>
    respond(404, %{ error: "Not found" })
  end

  defp respond(conn, status_code, response) do
    conn |>
    put_resp_content_type("application/json") |>
    send_resp(status_code, Poison.encode!(response))
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, response, _} -> MultiApi.TryParse.parse(response)
      _ -> ""
    end
  end
end
