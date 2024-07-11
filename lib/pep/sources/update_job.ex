defmodule Pep.Sources.UpdateJob do
  use GenServer, restart: :transient
  require Logger

  alias Pep.Sources.LatestAgent
  # <1>
  alias Pep.def(start_link(run_interval)) do
    GenServer.start_link(__MODULE__, run_interval, name: __MODULE__)
  end

  @impl true
  def init(run_interval) do
    # <2>
    {:ok, run_interval, {:continue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, run_interval) do
    Process.send_after(self(), :perform_cron_work, run_interval)
    {:noreply, run_interval}
  end

  @impl true
  def handle_info(:perform_cron_work, run_interval) do
    # TODO agent needs to return both the ID and ano_mes
    latest_source = LatestAgent.value()

    # TODO do the thing..
    LatestAgent.update()

    Logger.info("Performing cron work")

    {:noreply, run_interval, {:continue, :schedule_next_run}}
  end
end
