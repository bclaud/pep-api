defmodule Pep.Repo.Migrations.CreatePepsTable do
  use Ecto.Migration

  def change do
    create table(:peps) do
      add(:cpf, :string)
      add(:nome, :string)
      add(:sigla, :string)
      add(:descr, :string)
      add(:nivel, :string)
      add(:regiao, :string)
      add(:data_inicio, :string)
      add(:data_fim, :string)
      add(:data_carencia, :string)
      add(:source_id, references(:sources))

      timestamps()
    end
  end
end
