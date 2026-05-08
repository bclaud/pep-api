defmodule Pep.Sources.Create do
  alias Pep.Cloudflare.Purge
  alias Pep.{Error, Repo, Source}
  alias Pep.Sources.{Download, LatestAgent, Parser, Unzip}

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
      |> tap(&after_import(&1, ano_mes))
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

  defp after_import({:ok, _source}, ano_mes) do
    is_newer = newer_than_latest?(ano_mes)

    LatestAgent.update()

    if is_newer do
      Purge.call()
    end
  end

  defp after_import({:error, _reason}, _ano_mes), do: :ok

  defp newer_than_latest?(ano_mes) do
    previous_latest = LatestAgent.value()

    is_nil(previous_latest) or ano_mes > previous_latest.ano_mes
  end
end
