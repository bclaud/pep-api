defmodule PepWeb.PepsView do
  use PepWeb, :view

  alias Pep.Pep, as: PepStruct

  @attributes_show ~w(cpf nome sigla regiao data_inicio data_fim data_carincia id)

  def render("show.json", %{pep: peps}) do
    Enum.map(peps, &json_pep/1)
  end

  def json_pep(%PepStruct{} = pep) do
    %{
      nome: pep.nome,
      cpf_parcial: pep.cpf,
      sigla: pep.sigla,
      regiao: pep.regiao,
      data_inicio: pep.data_inicio,
      data_fim: pep.data_fim,
      data_carincia: pep.data_carincia,
      fonte: %{
        ano_mes: pep.source.ano_mes,
        data_de_insercao: naive_to_utc_sp(pep.source.inserted_at)
      }
    }
  end

  defp naive_to_utc_sp(naive_datetime) do
    DateTime.from_naive!(naive_datetime, "Etc/UTC")
    |> DateTime.shift_zone!("America/Sao_Paulo", Tzdata.TimeZoneDatabase)
  end
end
