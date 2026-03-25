defmodule Pep.Sources.UpdateJob do
  use GenServer, restart: :transient
  require Logger

  alias Pep.Sources.LatestAgent
  alias Pep.Sources.Create
  alias Pep

  def start_link(run_interval) do
    GenServer.start_link(__MODULE__, run_interval, name: __MODULE__)
  end

  @impl true
  def init(run_interval) do
    {:ok, run_interval, {:continue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, run_interval) do
    Process.send_after(self(), :perform_cron_work, run_interval)
    {:noreply, run_interval}
  end

  @impl true
  def handle_info(:perform_cron_work, run_interval) do
    Logger.info("#{__MODULE__} Performing cron job...")

    latest_source = LatestAgent.value()

    if is_nil(latest_source) do
      Logger.info("#{__MODULE__} Latest source is nil")
    else
      Logger.info("#{__MODULE__} Latest source is #{inspect(latest_source.ano_mes)}")
    end

    case latest_source do
      nil ->
        # I could easily start downloading the current source here but not sure if it's a good idea
        Logger.info(
          "#{__MODULE__} There is no pep source to look for. Skipping source update job"
        )

      source ->
        update_range = -3..3

        Enum.each(update_range, fn x ->
          target_ano_mes = shift_ano_mes(source.ano_mes, x)
          Logger.info("#{__MODULE__} Requesting #{target_ano_mes}...")
          Create.call(target_ano_mes)
        end)
    end

    Logger.info("#{__MODULE__} Updating agent")
    LatestAgent.update()

    Logger.info("#{__MODULE__} Finished cron job...")
    {:noreply, run_interval, {:continue, :schedule_next_run}}
  end

  def shift_ano_mes(<<ano::binary-size(4), mes::binary>>, x) do
    int_month = String.to_integer(mes)
    int_year = String.to_integer(ano)

    idx = int_month - 1
    total_idx = idx + x

    {years_to_add, shifted_idx} =
      if total_idx >= 0 do
        {div(total_idx, 12), rem(total_idx, 12)}
      else
        {div(total_idx + 1, 12) - 1, rem(total_idx + 1, 12) + 11}
      end

    int_shifted_year = int_year + years_to_add
    int_shifted_month = shifted_idx + 1

    formatted_month = String.pad_leading(Integer.to_string(int_shifted_month), 2, "0")
    Integer.to_string(int_shifted_year) <> formatted_month
  end
end
