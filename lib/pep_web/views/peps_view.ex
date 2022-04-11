defmodule PepWeb.PepsView do
  use PepWeb, :view

  alias Pep.Pep, as: PepStruct

  def render("show.json", %{pep: peps}) do
    Enum.map(peps, &json_pep/1)
  end

  defp json_pep(%PepStruct{} = pep) do
    %{
      nome: pep.nome,
      cpf_parcial: pep.cpf,
      sigla: pep.sigla,
      regiao: pep.regiao,
      data_inicio: pep.data_inicio,
      data_fim: pep.data_fim,
      data_carencia: pep.data_carencia,
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
