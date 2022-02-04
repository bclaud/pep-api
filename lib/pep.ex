defmodule Pep do
  alias Pep.Sources.Create, as: SourceCreate
  alias Pep.Sources.Get, as: SourceGet

  defdelegate create_source(mes_ano), to: SourceCreate, as: :call
  defdelegate list_sources(), to: SourceGet, as: :call
end
