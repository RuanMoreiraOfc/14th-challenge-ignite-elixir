defmodule Expi.Repo do
  use Ecto.Repo,
    otp_app: :expi,
    adapter: Ecto.Adapters.Postgres
end
