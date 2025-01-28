defmodule FlamingCool.Repo do
  use Ecto.Repo,
    otp_app: :flaming_cool,
    adapter: Ecto.Adapters.SQLite3
end
