defmodule MultiApi.Fetch do
  @invalid_argument %{ error: "Invalid argument" }
  def fetch(urls) when is_binary(urls), do: @invalid_argument
  def fetch(urls) when is_list(urls) do
    urls |>
    MultiApi.AsyncMap.async_map(&fetch_url/1, &as_map/1)
  end
  def fetch(_), do: @invalid_argument

  defp fetch_url(url) do
    {url, HTTPotion.get(url).body |> MultiApi.TryParse.parse}
  end

  defp as_map({ url, response }) do
    %{ url: url, response: response }
  end
end
