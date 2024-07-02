defmodule Pep.Repo.Migrations.AddNameIndex do
  use Ecto.Migration

  def change do
    create index("peps", :nome)
  end
end
