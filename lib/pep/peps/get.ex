defmodule Pep.Peps.Get do
  import Ecto.Query
  alias Pep.{Repo, Error}
  alias Pep.Pep, as: PepSchema

  def get_by_cpf(partial_cpf) do
    ultima_fonte = get_last_source()

    query =
      from(PepSchema, where: [cpf: ^partial_cpf, source_id: ^ultima_fonte], preload: [:source])

    case Repo.all(query) do
      pep -> {:ok, pep}
      # TODO arrumar a match abaixo
      [] -> {:error, Error.build_not_found_error()}
    end
  end

  def get_by_nome(nome) do
    nome = "%" <> nome <> "%"
    ultima_fonte = get_last_source()

    query =
      from p in PepSchema,
        where: ilike(p.nome, ^nome) and p.source_id == ^ultima_fonte,
        preload: [:source]

    case Repo.all(query) do
      pep -> {:ok, pep}
      [] -> {:error, Error.build_not_found_error()}
    end
  end

  def get_last_source() do
    query = from s in Pep.Source, select: [s.ano_mes, s.id]

    [_ano_mes, id] =
      Repo.all(query)
      |> Enum.map(fn each -> List.update_at(each, 0, &String.to_integer/1) end)
      |> Enum.max()

    id
  end
end
