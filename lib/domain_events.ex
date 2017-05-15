defmodule Estest.DomainEvents do
  defmodule CounterCreated, do: defstruct [aggregate_id: nil, created: nil]
  defmodule CounterIncremented, do: defstruct [aggregate_id: nil, created: nil]
end
