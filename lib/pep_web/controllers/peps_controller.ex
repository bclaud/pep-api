defmodule PepWeb.PepsController do
  use PepWeb, :controller
  alias PepWeb.FallbackController

  action_fallback FallbackController

  def show(conn, %{"partial_cpf" => partial_cpf} = _params) do
    with {:ok, peps} <- Pep.get_by_cpf(partial_cpf) do
      conn
      |> put_status(:ok)
      |> render("show.json", pep: peps)
    end
  end

  def show(conn, %{"nome" => nome} = _params) do
    with {:ok, peps} <- Pep.get_by_nome(nome) do
      conn
      |> put_status(:ok)
      |> render("show.json", pep: peps)
    end
  end
end
