defmodule Pep.Source do
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:ano_mes, :report_path, :source_path]

  schema "users" do
    field :ano_mes, :string
    field :report_path, :string
    field :source_path, :string


    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:ano_mes, is: 6)
  end
end
