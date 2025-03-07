defmodule Pep.Peps.Get do
  import Ecto.Query
  alias Pep.Repo
  alias Pep.Pep, as: PepSchema
  alias Pep.Sources.LatestAgent

  def get_by_cpf(partial_cpf) do
    ultima_fonte_id = LatestAgent.value().id

    query =
      from(PepSchema, where: [cpf: ^partial_cpf, source_id: ^ultima_fonte_id], preload: [:source])

    pep = Repo.all(query)

    {:ok, pep}
  end

  def get_by_nome(nome) do
    nome = "%" <> nome <> "%"
    ultima_fonte = LatestAgent.value().id

    query =
      from p in PepSchema,
        where: like(p.nome, ^nome) and p.source_id == ^ultima_fonte,
        preload: [:source]

    pep = Repo.all(query)

    {:ok, pep}
  end

  def get_last_source() do
    query = from s in Pep.Source, select: [s.ano_mes, s.id]

    result = Repo.all(query)

    case result do
      [] ->
        nil

      _ ->
        [_ano_mes, id] =
          result
          |> Enum.map(fn each -> List.update_at(each, 0, &String.to_integer/1) end)
          |> Enum.max()

        Repo.get(Pep.Source, id)
    end
  end
end
