defmodule Pep.Peps.Get do
  import Ecto.Query
  alias Pep.Repo
  alias Pep.Pep, as: PepSchema

  def get_by_cpf(partial_cpf) do
    ultima_fonte = get_last_source()

    query =
      from(PepSchema, where: [cpf: ^partial_cpf, source_id: ^ultima_fonte], preload: [:source])

    pep = Repo.all(query)

    {:ok, pep}
  end

  def get_by_nome(nome) do
    nome = "%" <> nome <> "%"
    ultima_fonte = get_last_source()

    query =
      from p in PepSchema,
        where: ilike(p.nome, ^nome) and p.source_id == ^ultima_fonte,
        preload: [:source]

    pep = Repo.all(query)

    {:ok, pep}
  end

  defp get_last_source() do
    query = from s in Pep.Source, select: [s.ano_mes, s.id]

    [_ano_mes, id] =
      Repo.all(query)
      |> Enum.map(fn each -> List.update_at(each, 0, &String.to_integer/1) end)
      |> Enum.max()

    id
  end
end
