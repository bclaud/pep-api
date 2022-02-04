defmodule PepWeb.SourcesController do
  use PepWeb, :controller

  alias Pep.Source
  alias PepWeb.FallbackController

  action_fallback FallbackController

  def create(conn, %{"ano_mes" => ano_mes} = _params) do
    with {:ok, %Source{} = source} <- Pep.create_source(ano_mes) do
      conn
      |> put_status(:created)
      |> render("create.json", source: source)
    end
  end

  def show(conn, _params) do
    with source_list <- Pep.list_sources() do
      conn
      |> put_status(:ok)
      |> render("show.json", source: source_list)
    end
  end
end
