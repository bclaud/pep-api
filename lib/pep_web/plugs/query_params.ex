defmodule PepWeb.Plugs.QueryParams do
  @moduledoc """
    Plug para evitar a sobrecarga má intencionada do banco de dados atraves do query utilizando "ilike"
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(%{params: %{"partial_cpf" => partial_cpf}} = conn, _opts) do
    case valid_string?(partial_cpf) && String.length(partial_cpf) >= 3 do
      true -> conn
      false -> render_error(conn)
    end
  end

  def call(%{params: %{"nome" => nome}} = conn, _opts) do
    case valid_string?(nome) && String.length(nome) >= 3 do
      true -> conn
      false -> render_error(conn)
    end
  end

  def call(conn, _opts), do: conn

  defp valid_string?(string) do
    valid_char? = fn char -> char not in ["%"] end

    string
    |> String.graphemes()
    |> Enum.all?(&valid_char?.(&1))
  end

  defp render_error(conn) do
    body = Jason.encode!(%{message: "Characteres invalidos ou parametro curto (menor que tres)"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:bad_request, body)
    |> halt()
  end
end
