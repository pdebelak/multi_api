defmodule MultiApi.TryParse do
  def parse(json) do
    case Poison.decode(json) do
      {:ok, parsed} -> parsed
      {:error, _} -> json
    end
  end
end
