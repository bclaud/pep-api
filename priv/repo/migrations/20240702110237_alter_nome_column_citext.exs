defmodule Pep.Repo.Migrations.AlterNomeColumnCitext do
  use Ecto.Migration

  def change do
    alter table("peps") do
      modify :nome, :citext
    end

  end
end
