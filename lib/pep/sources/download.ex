defmodule Pep.Sources.Download do
  alias Pep.Error

  def call(ano_mes) do
    create_directories()

    case get_zip(ano_mes) do
      {:ok, zip_body} -> write_zip(zip_body, ano_mes)
      {:error, _reason} = error -> error
    end
  end

  defp get_zip(ano_mes) do
    url = "https://transparencia.gov.br/download-de-dados/pep/" <> ano_mes

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: zip_body, status_code: 200}} ->
        {:ok, zip_body}

      {:ok, %HTTPoison.Response{body: _zip_body, status_code: 404}} ->
        {:error, Error.build(:not_found, "Arquivo nao encontrado para o ano_mes informado")}

      {:ok, %HTTPoison.Response{body: _zip_body, status_code: _}} ->
        {:error, Error.build(:bad_request, "Resposta inesperada do servidor da transparencia")}
    end
  end

  defp write_zip(zip_body, ano_mes) do
    path = "priv/downloaded/zip/" <> ano_mes <> ".zip"

    case File.write(path, zip_body) do
      :ok -> {:ok, path}
      {:error, _reason} -> {:error, Error.build(:bad_request, "Erro ao salvar zip")}
    end
  end

  defp create_directories do
    downloads_path = "priv/downloaded/zip"

    case File.exists?(downloads_path) do
      true -> :ok
      false -> File.mkdir_p!(downloads_path)
    end
  end
end
