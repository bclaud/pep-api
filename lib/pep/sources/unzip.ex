defmodule Pep.Sources.Unzip do
  def call(source_path) do
    report_folder = "priv/reports/"

    erl_source_path = String.to_charlist(source_path)
    erl_report_folder = String.to_charlist(report_folder)

    case :zip.unzip(erl_source_path, [{:cwd, erl_report_folder}]) do
      {:ok, [report_path]} -> {:ok, to_string(report_path)}
      {:error, reason} -> {:error, reason}
    end
  end
end
