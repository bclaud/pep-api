defmodule Pep.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pep.Repo,
      # Start the Telemetry supervisor
      PepWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pep.PubSub},
      # Start the Endpoint (http/https)
      PepWeb.Endpoint,
      # Start a worker by calling: Pep.Worker.start_link(arg)
      # {Pep.Worker, arg}
      {Pep.Sources.LatestAgent, 0}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pep.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PepWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
