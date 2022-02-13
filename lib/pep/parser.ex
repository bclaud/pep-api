defmodule Pep.Parser do
  def call(ano_mes) do
    ano_mes
    |> get_csv()
    |> remove_header()
    |> parse_lines()
    |> to_map()
    |> adjust_fields()
  end

  defp get_csv(ano_mes) do
    path = "priv/reports/" <> ano_mes <> "_PEP.csv"

    File.stream!(path)
  end

  defp remove_header(report_csv) do
    report_csv
    |> Stream.drop(1)
  end

  defp parse_lines(content) do
    content
    |> Enum.map(fn line -> String.trim(line) end)
    |> Enum.map(fn line -> String.split(line, ";", trim: true) end)
  end

  defp to_map(content) do
    content
    |> Enum.map(fn [cpf, nome, sigla, descr, nivel, regiao, data_inicio, data_fim, data_carincia] =
                     _line ->
      %{
        cpf: cpf,
        nome: nome,
        sigla: sigla,
        descr: descr,
        nivel: nivel,
        regiao: regiao,
        data_inicio: data_inicio,
        data_fim: data_fim,
        data_carincia: data_carincia
      }
    end)
  end

  defp adjust_fields(content) do
    content
    |> Enum.map(fn %{
                     cpf: cpf,
                     nome: nome,
                     sigla: sigla,
                     descr: descr,
                     nivel: nivel,
                     regiao: regiao,
                     data_inicio: data_inicio,
                     data_fim: data_fim,
                     data_carincia: data_carincia
                   } = _line ->
      %{
        cpf: sanitize_cpf(cpf),
        nome: nomalize_str(nome),
        sigla: remove_quotes(sigla),
        descr: remove_quotes(descr),
        nivel: remove_quotes(nivel),
        regiao: remove_quotes(regiao),
        data_inicio: handle_date(data_inicio),
        data_fim: handle_date(data_fim),
        data_carincia: handle_date(data_carincia),
        cpf_nome: sanitize_cpf(cpf) <> remove_quotes(nome)
      }
    end)
  end

  defp nomalize_str(str) do
    str
    |> String.normalize(:nfd)
    |> String.replace("\"", "")
    |> String.replace(~r/[^A-Za-z\s]/u, "")
  end

  defp remove_quotes(str) do
    Enum.join(for <<c::utf8 <- str>>, do: <<c::utf8>>)
    |> String.replace("\"", "")
  end

  defp sanitize_cpf(cpf) do
    cpf
    |> remove_quotes
    |> String.replace(["*", ".", "-"], "")
  end

  defp handle_date(date) do
    case adjust_date(date) do
      {:ok, _date_type} ->
        remove_quotes(date)

      {:error, _reason} ->
        "Nao informado"
    end
  end

  defp adjust_date(date) do
    date
    |> remove_quotes()
    |> String.split("/")
    |> Enum.reverse()
    |> Enum.join("-")
    |> Date.from_iso8601()
  end
end
