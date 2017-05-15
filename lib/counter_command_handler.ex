defmodule Estest.CounterCommandHandler do
  alias Estest.Aggregate
  alias Estest.Commands.{
    CreateCounter,
    IncrementCounter
  }
  alias Estest.Counter

  def execute(%CreateCounter{} = c) do
    Aggregate.call(c.aggregate_id,
      fn state -> state |> Counter.create(c.aggregate_id) end)
  end
  def execute(%IncrementCounter{} = c) do
    Aggregate.call(c.aggregate_id,
      fn state -> state |> Counter.increment() end)
  end
end
