defmodule Estest do
	import Supervisor.Spec

  def start() do
    children = [
      supervisor(Registry, [:unique, Registry.Aggregates]),
      supervisor(Estest.AggregateSupervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
