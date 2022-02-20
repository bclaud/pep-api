defmodule Pep do
  alias Pep.Sources.Create, as: SourceCreate
  alias Pep.Sources.Get, as: SourceGet
  alias Pep.Peps.Get, as: PepGet

  defdelegate create_source(mes_ano), to: SourceCreate, as: :call
  defdelegate list_sources(), to: SourceGet, as: :call
  defdelegate get_by_cpf(partial_cpf), to: PepGet, as: :get_by_cpf
end
