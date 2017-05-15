defmodule Estest.AggregateSupervisor do
  alias Estest.Aggregate
  use Supervisor

  ## Public API

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## GenServer callbacks

  def init([]) do
    children = [
      worker(Aggregate, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_child(id) do
    Supervisor.start_child(__MODULE__, [id])
  end
end
