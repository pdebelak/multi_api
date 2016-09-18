defmodule MultiApi do
  use Application

  def start(_type, _args) do
    Plug.Adapters.Cowboy.http MultiApi.Server, [], [port: 3456]
  end
end
