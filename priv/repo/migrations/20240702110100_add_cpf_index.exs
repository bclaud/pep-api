defmodule Pep.Repo.Migrations.Add_CPFIndex do
  use Ecto.Migration

  def change do
    create index("peps", :cpf)
  end
end
