defmodule Pep.Repo.Migrations.Sources do
  use Ecto.Migration


  def change do
    create table (:sources) do
      add :ano_mes, :string
      add :report_path, :string
      add :source_path, :string

      timestamps()
    end

    create unique_index(:sources, [:ano_mes])
    create unique_index(:sources, [:report_path])
    create unique_index(:sources, [:source_path])
  end
end
