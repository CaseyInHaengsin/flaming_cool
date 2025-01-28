defmodule FlamingCoolWeb.ApiController do
  use FlamingCoolWeb, :controller

  def index(conn, _params) do
    FLAME.call(FlamingCool.Flamethrower, fn ->
      IO.puts("yooooooo")
    end)

    json(conn, %{message: "Hello, World!"})
  end
end
