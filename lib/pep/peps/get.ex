defmodule Pep.Peps.Get do
  import Ecto.Query
  alias Pep.{Repo, Source, Error}
  alias Pep.Pep, as: PepStruct

  def get_by_cpf(partial_cpf) do
    query = from(Pep.Pep, where: [cpf: ^partial_cpf])

    case Repo.all(query) |> Repo.preload(:source) do
      pep -> {:ok, pep}
      # TODO arrumar a match abaixo
      [] -> {:error, Error.build_not_found_error()}
    end
  end

  def get_by_nome(nome) do
    # query = from(Pep.Pep, where: [])
  end
end
