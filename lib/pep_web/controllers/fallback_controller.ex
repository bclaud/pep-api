defmodule PepWeb.FallbackController do
  use PepWeb, :controller

  alias PepWeb.ErrorView
  alias Pep.Error

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
