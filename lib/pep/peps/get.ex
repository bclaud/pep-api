defmodule Pep.Peps.Get do
  import Ecto.Query
  alias Pep.{Repo, Error}
  alias Pep.Pep, as: PepSchema

  def get_by_cpf(partial_cpf) do
    query = from(PepSchema, where: [cpf: ^partial_cpf])

    case Repo.all(query) |> Repo.preload(:source) do
      pep -> {:ok, pep}
      # TODO arrumar a match abaixo
      [] -> {:error, Error.build_not_found_error()}
    end
  end

  def get_by_nome(nome) do
    nome = "%" <> nome <> "%"
    query = from p in PepSchema, where: ilike(p.nome, ^nome)

    case Repo.all(query) |> Repo.preload(:source) do
      pep -> {:ok, pep}
      [] -> {:error, Error.build_not_found_error()}
    end
  end
end
