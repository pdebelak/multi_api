defmodule MultiApi.Server do
  import Plug.Conn

  @usage ~s<Usage: Post urls as array to `/`. Response will be in form `[{"url":URL,"response":RESPONSE},...etc]`.>

  def init(default_opts) do
    IO.puts "starting up MultiApi..."
    default_opts
  end

  def call(conn, _opts) do
    conn |>
    route(conn.method, conn.path_info, conn |> get_req_header("content-type"))
  end

  defp route(conn, "POST", [], _) do
    conn |>
    respond(200, MultiApi.Fetch.fetch(body(conn)))
  end

  defp route(conn, "GET", [], ["application/json"]) do
    conn |>
    respond(200, @usage)
  end

  require EEx
  EEx.function_from_file :defp, :template_home_page, "templates/home.eex", [:url]
  defp route(conn, "GET", [], _) do
    conn |>
    put_resp_content_type("text/html") |>
    send_resp(200, template_home_page(req_url(conn)))
  end

  defp route(conn, _, _, _) do
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

  defp req_url(%Plug.Conn{scheme: scheme, host: host, port: port}) do
    port_repr = case {scheme, port} do
      {:http, 80} -> ""
      {:https, 443} -> ""
      {_, port} -> ":#{port}"
    end
    "#{scheme}://#{host}#{port_repr}/"
  end
end
