defmodule Pep.Peps.Playground do
  alias Pep.Repo
  alias Pep.Pep, as: PepSchema
  alias Pep.Peps.Get

  import Ecto.Query

  def get_all_peps() do
    Repo.all(PepSchema)
  end

  # media 10000
  def tcpf_filter(peps, cpf) do
    :timer.tc(fn -> Enum.filter(peps, fn pep -> pep.cpf == cpf end) end)
  end

  # media 20000
  def tcpf_repo(cpf) do
    :timer.tc(fn -> Get.get_by_cpf(cpf) end)
  end

  # AQUI PRA BAIXO EH POR NOME

  # silva -> 142163, 155213
  # bolsonaro -> 179267
  def tnome_filter(peps, nome) do
    :timer.tc(fn ->
      Enum.filter(peps, fn pep ->
        String.contains?(String.downcase(pep.nome), String.downcase(nome))
      end)
    end)
  end

  # silva -> 222910, 345350,
  # bolsonaro -> 84612, 88262
  def tnome_repo(nome) do
    :timer.tc(fn -> Get.get_by_nome(nome) end)
  end

  # silva -> 596654
  # bolsonaro -> 1140
  def filter_ids_by_name_and_search_repo(tuples, search_name) do
    ids =
      for {id, name} <- tuples,
          String.contains?(String.downcase(name), String.downcase(search_name)),
          do: id

    query = from p in PepSchema, where: p.id in ^ids

    :timer.tc(fn -> Repo.all(query) end)
  end

  def get_all_peps_name() do
    query = from p in PepSchema, select: {p.id, p.nome}

    Repo.all(query)
  end
end
