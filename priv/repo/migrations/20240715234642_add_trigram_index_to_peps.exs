defmodule Pep.Repo.Migrations.AddTrigramIndexToPeps do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"

    execute "CREATE INDEX idx_peps_nome_trgm ON peps USING GIN (nome gin_trgm_ops)"
  end

  def down do
    execute "DROP INDEX IF EXISTS idx_peps_nome_trgm"
  end
end
