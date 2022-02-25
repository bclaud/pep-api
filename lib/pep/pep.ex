defmodule Pep.Pep do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @all_fields ~w(cpf nome sigla descr nivel regiao data_inicio data_fim data_carincia source_id)a
  @required_fields ~w(cpf nome data_inicio data_fim data_carincia )a

  schema "peps" do
    field :cpf, :string
    field :nome, :string
    field :sigla, :string
    field :descr, :string
    field :nivel, :string
    field :regiao, :string
    field :data_inicio, :string
    field :data_fim, :string
    field :data_carincia, :string
    belongs_to :source, Pep.Source, type: :binary_id

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end
end
