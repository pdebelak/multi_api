defmodule MultiApi.Fetch do
  @invalid_argument %{ error: "Invalid argument" }
  def fetch(urls) when is_binary(urls), do: @invalid_argument
  def fetch(urls) when is_list(urls) do
    urls |>
    MultiApi.AsyncMap.async_map(&fetch_url/1, &as_map/1)
  end
  def fetch(_), do: @invalid_argument

  defp fetch_url(url) do
    {url, get_body(url)}
  end

  defp as_map({ url, response }) do
    %{ url: url, response: response }
  end

  defp get_body(url) do
    case HTTPotion.get(url) do
      %HTTPotion.Response{ body: body } -> MultiApi.TryParse.parse(body)
      %HTTPotion.ErrorResponse{ message: message } -> %{ error: message }
    end
  end
end
