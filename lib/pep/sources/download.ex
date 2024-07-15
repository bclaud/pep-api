defmodule Pep.Sources.Download do
  require Logger
  alias Pep.Error

  def call(ano_mes) do
    Logger.info("Starting downloading #{ano_mes}")
    create_directories()

    case get_zip(ano_mes) do
      {:ok, zip_body} ->
        Logger.info("Download successful ano_mes=#{ano_mes}")
        write_zip(zip_body, ano_mes)

      {:error, _reason} = error ->
        Logger.info("Download failed ano_mes=#{ano_mes}")
        error
    end
  end

  defp get_zip(ano_mes) do
    url = "https://transparencia.gov.br/download-de-dados/pep/" <> ano_mes

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{body: zip_body, status_code: 200}} ->
        {:ok, zip_body}

      {:ok, %HTTPoison.Response{body: _zip_body, status_code: 404}} ->
        {:error, Error.build(:not_found, "Arquivo nao encontrado para o ano_mes informado")}

      {:ok, %HTTPoison.Response{body: _resp, status_code: _}} ->
        {:error, Error.build(:bad_request, "Resposta inesperada do servidor da transparencia")}
    end
  end

  defp write_zip(zip_body, ano_mes) do
    path = "/tmp/elixir_pep/downloaded/zip/" <> ano_mes <> ".zip"

    case File.write(path, zip_body) do
      :ok -> {:ok, path}
      {:error, _reason} -> {:error, Error.build(:bad_request, "Erro ao salvar zip")}
    end
  end

  defp create_directories do
    downloads_path = "/tmp/elixir_pep/downloaded/zip"

    case File.exists?(downloads_path) do
      true -> :ok
      false -> File.mkdir_p!(downloads_path)
    end
  end
end
