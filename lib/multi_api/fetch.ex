defmodule MultiApi.Fetch do
  @invalid_argument %{ error: "Invalid argument" }
  def fetch(urls) when is_binary(urls), do: @invalid_argument
  def fetch(urls) when is_list(urls) do
    urls |>
    MultiApi.AsyncMap.async_map(&fetch_url/1) |>
    Enum.map(&as_map/1)
  end
  def fetch(_), do: @invalid_argument

  defp fetch_url(url) do
    {url, HTTPotion.get(url)}
  end

  defp as_map({url, %HTTPotion.Response{ body: body, status_code: status_code }}) do
    %{ url: url, response: MultiApi.TryParse.parse(body), status_code: status_code }
  end
  defp as_map({url, %HTTPotion.ErrorResponse{ message: message}}) do
    %{ url: url, error: message }
  end
end
