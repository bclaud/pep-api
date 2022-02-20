defmodule PepWeb.PepsController do
  use PepWeb, :controller
  alias Pep.{Repo}
  alias Pep.Pep, as: PepStruct
  alias PepWeb.FallbackController

  action_fallback FallbackController

  def show(conn, %{"partial_cpf" => partial_cpf} = _params) do
    with {:ok, pep} <- Pep.get_by_cpf(partial_cpf) do
      conn
      |> put_status(:ok)
      |> render("show.json", pep: pep)
    end
  end
end
