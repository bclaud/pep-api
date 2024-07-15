defmodule PepWeb.SourcesView do
  use PepWeb, :view
  alias Pep.Source

  @attributes_show ~w(inserted_at ano_mes)a

  def render("create.json", %{source: %Source{} = source}) do
    %{source: Map.take(source, @attributes_show), message: "Source importada"}
  end

  def render("show.json", %{source: sources_list}) do
    utc_source_list =
      Enum.map(sources_list, fn %{inserted_at: naive_datetime} = source ->
        %{source | inserted_at: naive_to_utc(naive_datetime)}
      end)

    Enum.map(utc_source_list, fn source -> Map.take(source, @attributes_show) end)
  end

  defp naive_to_utc(naive_datetime) do
    DateTime.from_naive!(naive_datetime, "Etc/UTC")
  end
end
