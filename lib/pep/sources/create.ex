defmodule Pep.Sources.Create do
  alias Pep.{Source, Repo, Error}

  alias Pep.Pep, as: PepStruct
  alias Pep.Parser
  alias Ecto.Changeset

  def call(ano_mes) when is_binary(ano_mes) do
    with :ok <- new_source?(ano_mes),
         {:ok, zip_body} <- get_zip(ano_mes),
         {:ok, zip_path} <- write_zip(zip_body, ano_mes),
         {:ok, report_path} <- unzip(zip_path) do
      %{ano_mes: ano_mes, source_path: zip_path, report_path: report_path}
      |> Source.changeset()
      |> Repo.insert()
      |> handle_source()

      import_to_db(ano_mes)
    end
  end

  def call(_ano_mes),
    do: {:error, Error.build(:bad_request, "ano_mes digitado incorretamente. Exemplo: 202112")}

  def import_to_db(ano_mes) do
    changesets =
      ano_mes
      |> Parser.call()
      |> Enum.map(fn item -> PepStruct.changeset(item) end)

    invalid_changesets = Enum.filter(changesets, fn changeset -> changeset.valid? == false end)
    # IO.inspect(changesets)
    Enum.each(changesets, fn changeset -> Repo.insert(changeset) end)
    # Repo.transaction(fn -> Enum.each(changesets, &Repo.update!(&1, [])) end)
  end

  defp new_source?(ano_mes) do
    case Repo.get_by(Source, ano_mes: ano_mes) do
      nil ->
        :ok

      %Source{} = _source ->
        {:error,
         Error.build(:bad_request, "Source " <> ano_mes <> " ja adicionada ao banco de dados")}
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

  defp unzip(source_path) do
    report_folder = "priv/reports/"

    erl_source_path = String.to_charlist(source_path)
    erl_report_folder = String.to_charlist(report_folder)

    case :zip.unzip(erl_source_path, [{:cwd, erl_report_folder}]) do
      {:ok, [report_path]} -> {:ok, to_string(report_path)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_source({:ok, %Source{}} = source), do: source

  defp handle_source({:error, %Changeset{} = changeset}) do
    {:error, Error.build(:bad_request, changeset)}
  end
end
