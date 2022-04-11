defmodule Pep.Sources.Create do
  alias Pep.{Source, Repo, Error}
  alias Pep.Sources.{Download, Unzip, Parser}

  alias Ecto.Changeset

  def call(ano_mes) when is_binary(ano_mes) do
    with :ok <- new_source?(ano_mes),
         {:ok, zip_path} <- Download.call(ano_mes),
         {:ok, report_path} <- Unzip.call(zip_path) do
      %{ano_mes: ano_mes, source_path: zip_path, report_path: report_path}
      |> Source.changeset()
      |> Repo.insert()
      |> parse_and_import_peps()
      |> handle_source()
    end
  end

  def call(_ano_mes),
    do: {:error, Error.build(:bad_request, "ano_mes digitado incorretamente. Exemplo: 202112")}

  defp new_source?(ano_mes) do
    case Repo.get_by(Source, ano_mes: ano_mes) do
      nil ->
        :ok

      %Source{} = _source ->
        {:error,
         Error.build(:bad_request, "Source " <> ano_mes <> " ja adicionada ao banco de dados")}
    end
  end

  defp parse_and_import_peps({:ok, %Source{ano_mes: ano_mes}} = source) do
    Parser.import_to_db(ano_mes)

    source
  end

  defp parse_and_import_peps({:error, _} = source), do: source

  defp handle_source({:ok, %Source{}} = source), do: source

  defp handle_source({:error, %Changeset{} = changeset}) do
    {:error, Error.build(:bad_request, changeset)}
  end
end
