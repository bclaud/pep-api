defmodule Pep.Sources.LatestAgent do
  @moduledoc """
  Holds and updates the value of latest imported source
  alias Credo.Check.Readability.ModuleDoc
  """
  use Agent

  alias Pep.Peps.Get

  def start_link(_) do
    Agent.start_link(fn -> Get.get_last_source() end, name: __MODULE__)
  end

  @doc """
  Get the ID of latest source
  """
  @spec value() :: String.t()
  def value do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Updates to latest id
  """
  @spec update() :: :ok
  def update do
    Agent.update(__MODULE__, fn _state -> Get.get_last_source() end)
  end
end
