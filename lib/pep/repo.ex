defmodule Pep.Repo do
  use Ecto.Repo,
    otp_app: :pep,
    adapter: Ecto.Adapters.Postgres
end
