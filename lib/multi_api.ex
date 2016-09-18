defmodule MultiApi do
  use Application

  def start(_type, _args) do
    Plug.Adapters.Cowboy.http MultiApi.Server, []
  end
end
