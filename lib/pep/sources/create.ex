defmodule Pep.Sources.Create do
  alias Pep.{Source, Repo}

  def call(ano_mes) when is_binary(ano_mes) do
    with {:ok, zip_body} <- get_zip(ano_mes),
         {:ok, zip_path} <- write_zip(zip_body, ano_mes)
         {:ok, report_path} <- unzip(zip_path, ano_mes) do
      %{ano_mes: ano_mes, source_path: zip_path, report_path: report_path}
      |> Source.changeset()
    end
  end

  def call(_ano_mes), do: {:error, "ano_mes digitado incorretamente. Exemplo: 202112"}

  defp get_zip(ano_mes) do
    url = "https://transparencia.gov.br/download-de-dados/pep/" <> ano_mes

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: zip_body, status_code: 200}} ->
        {:ok, zip_body}

      {:ok, %HTTPoison.Response{body: _zip_body, status_code: 404}} ->
        {:error, "Arquivo nao encontrado para o ano_mes informado"}
    end
  end

  defp write_zip(zip_body, ano_mes) do
    path = "priv/downloaded/zip/" <> ano_mes <> ".zip"
    IO.inspect(path, label: "Path:::::::")

    case File.write(path, zip_body) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, "Erro ao salvar zip"}
      IO.inspect(reason, label: "Reason:::::")
    end
  end
end
