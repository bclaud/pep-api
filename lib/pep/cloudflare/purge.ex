defmodule Pep.Cloudflare.Purge do
  @moduledoc """
  Purges Cloudflare cache when a new PEP source is imported.
  """
  require Logger

  def call do
    Task.start(fn ->
      case config() do
        {:ok, zone_id, api_token} ->
          purge_cache(zone_id, api_token)

        :not_configured ->
          Logger.debug("Cloudflare not configured, skipping cache purge")
      end
    end)
  end

  defp purge_cache(zone_id, api_token) do
    url = "https://api.cloudflare.com/client/v4/zones/#{zone_id}/purge_cache"
    headers = [
      {"Authorization", "Bearer #{api_token}"},
      {"Content-Type", "application/json"}
    ]
    body = Jason.encode!(%{purge_everything: true})

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: resp_body}} ->
        case Jason.decode(resp_body) do
          {:ok, %{"success" => true}} ->
            Logger.info("Cloudflare cache purged successfully")

          {:ok, %{"success" => false, "errors" => errors}} ->
            Logger.error("Cloudflare cache purge failed: #{inspect(errors)}")

          _ ->
            Logger.error("Cloudflare cache purge returned unexpected response: #{resp_body}")
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        Logger.error("Cloudflare cache purge HTTP #{code}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Cloudflare cache purge request failed: #{inspect(reason)}")
    end
  end

  defp config do
    cloudflare = Application.get_env(:pep, :cloudflare)

    if cloudflare && cloudflare[:zone_id] && cloudflare[:api_token] do
      {:ok, cloudflare[:zone_id], cloudflare[:api_token]}
    else
      :not_configured
    end
  end
end
