defmodule Lov.Repo do
  use Ecto.Repo,
    otp_app: :lov,
    adapter: Ecto.Adapters.Postgres
end
