defmodule PepWeb.SourcesView do
  use PepWeb, :view

  alias Pep.Source

  @attributes_show ~w(inserted_at ano_mes)a

  def render("create.json", %{source: %Source{} = source}) do
    %{source: Map.take(source, @attributes_show), message: "Source importada"}
  end
end
