defmodule Pep.Parser do
  NimbleCSV.define(CSVParser, separator: ";", escape: "\"")

  def import_to_db(ano_mes) do
    path =
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
                         data_carincia
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
          data_carincia: :binary.copy(data_carincia)
        }
      end)
      |> Enum.to_list()
      |> Enum.map(fn pep -> fix_enconding(pep) end)
      |> Enum.map(fn %{cpf: cpf} = pep -> %{pep | cpf: sanitize_cpf(cpf)} end)
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
