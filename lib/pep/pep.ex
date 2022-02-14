defmodule Pep.Pep do
  use Ecto.Schema

  import Ecto.Changeset

  @all_fields ~w(cpf nome sigla descr nivel regiao data_inicio data_fim data_carincia cpf_nome)a
  @required_fields ~w(cpf nome data_inicio data_fim data_carincia cpf_nome)a

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
    field :cpf_nome, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:cpf_nome)
  end
end
