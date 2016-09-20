defmodule MultiApi.Router do
  use Plug.Router

  plug Plug.Static, at: "/public",
                    from: :multi_api
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  @usage ~s<Usage: Post urls as array to `/` in format {"urls":[...]}. Response will be in form `[{"url":URL,"response":RESPONSE},...etc]`.>

  get "/" do
    if conn |> get_req_header("content-type") == ["application/json"] do
      json_usage(conn)
    else
      html_home_page(conn)
    end
  end

  post "/" do
    respond(conn, 200, MultiApi.Fetch.fetch(conn.body_params["urls"]))
  end

  defp json_usage(conn), do: respond(conn, 200, @usage)

  require EEx
  EEx.function_from_file :defp, :template_home_page, "lib/templates/home.eex", [:url]
  defp html_home_page(conn) do
    conn |>
    put_resp_content_type("text/html") |>
    send_resp(200, template_home_page(req_url(conn)))
  end

  match _ do
    conn |>
    respond(404, %{ error: "Not found" })
  end

  defp respond(conn, status_code, response) do
    conn |>
    put_resp_content_type("application/json") |>
    send_resp(status_code, Poison.encode!(response))
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
