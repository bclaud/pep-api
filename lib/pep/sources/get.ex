defmodule Pep.Sources.Get do
  alias Pep.{Source, Repo}

  def call() do
    Repo.all(Source)
  end
end
