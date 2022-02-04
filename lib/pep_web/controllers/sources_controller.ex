defmodule PepWeb.SoucesController do
  use PepWeb, :controller

  alias Pep.Source

  def create(conn, params) do
    with {:ok, %Source{} = source} <- Pep.create_source(params) do
      conn
      |> put_status(:created)
      |> render("create.json", source: source)
    end
  end
end
