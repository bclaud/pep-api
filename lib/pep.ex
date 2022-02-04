defmodule Pep do
  alias Pep.Sources.Create, as: SourceCreate

  defdelegate create_source(mes_ano), to: SourceCreate, as: :call
end
