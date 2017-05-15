defmodule Estest.Counter do
  alias Estest.Counter
  alias Estest.DomainEvents.{
    CounterCreated,
    CounterIncremented
  }

  defstruct [
    aggregate_id: nil,
    count: 0
  ]

  ## Public API

  def create({state, events}, aggregate_id) do
    case state do
      %Counter{aggregate_id: ^aggregate_id} ->
        {state, {:error, "Already exists"}}
      _ ->
        {state, events} |> apply_event(%CounterCreated{aggregate_id: aggregate_id})
    end
  end

  def increment({state, events}) do
    {state, events} |> apply_event(%CounterIncremented{aggregate_id: state.aggregate_id})
  end

  ## Private API
  defp next_state(%CounterCreated{} = e, _state), do: %Counter{aggregate_id: e.aggregate_id}
  defp next_state(%CounterIncremented{}, state), do: %{state | count: state.count + 1}

  defp apply_event({_state, {:error, _reason}} = ret, _event), do: ret
  defp apply_event({state, events}, event) do
    {next_state(event, state), [event | events]}
  end

end
