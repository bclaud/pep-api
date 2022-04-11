defmodule Pep.Sources.Parser do
  NimbleCSV.define(CSVParser, separator: ";", escape: "\"")

  alias Pep.Pep, as: PepStruct
  alias Pep.{Repo, Source}

  def import_to_db(ano_mes) do
    Task.async(fn -> parse_import_to_db(ano_mes) end)
  end

  defp parse_import_to_db(ano_mes) do
    source = Repo.get_by(Source, ano_mes: ano_mes)

    parse(source)
    |> Stream.map(fn pep -> PepStruct.changeset(pep) end)
    |> Enum.each(fn changeset -> Pep.Repo.insert(changeset) end)
  end

  defp parse(%{ano_mes: ano_mes, id: id} = _source) do
    ("priv/reports/" <> ano_mes <> "_PEP.csv")
    |> File.stream!()
    |> CSVParser.parse_stream()
    |> Stream.map(fn [
                       cpf,
                       nome,
                       sigla,
                       descr,
                       nivel,
                       regiao,
                       data_inicio,
                       data_fim,
                       data_carencia
                     ] ->
      %{
        cpf: :binary.copy(cpf),
        nome: :binary.copy(nome),
        sigla: :binary.copy(sigla),
        descr: :binary.copy(descr),
        nivel: :binary.copy(nivel),
        regiao: :binary.copy(regiao),
        data_inicio: :binary.copy(data_inicio),
        data_fim: :binary.copy(data_fim),
        data_carencia: :binary.copy(data_carencia),
        source_id: ""
      }
    end)
    |> Stream.map(fn pep -> fix_enconding(pep) end)
    |> Stream.map(fn pep -> %{pep | source_id: id} end)
    |> Stream.map(fn %{cpf: cpf} = pep -> %{pep | cpf: sanitize_cpf(cpf)} end)
    |> Enum.to_list()
  end

  defp fix_enconding(pep) do
    pep
    |> Enum.map(fn {key, value} -> {key, latin1_to_utf8(value)} end)
    |> Enum.into(%{})
  end

  defp latin1_to_utf8(binary),
    do:
      :unicode.characters_to_binary(
        binary,
        :latin1,
        :utf8
      )

  defp sanitize_cpf(cpf) do
    cpf
    |> String.replace(["*", ".", "-"], "")
  end
end
