defmodule Estest.Aggregate do
	use GenServer

  ## Public API
  def start_link(aggregate_id) do
    GenServer.start_link(__MODULE__, aggregate_id, name: via(aggregate_id))
  end

  def call(aggregate_id, function) do
    try do
      GenServer.call(via(aggregate_id), function)
    catch
      :exit, {:noproc, _} ->
        case Estest.AggregateSupervisor.start_child(aggregate_id) do
          {:ok, child} ->
            GenServer.call(child, function)
          {:error, _} ->
            raise "Cannot create process for aggregate root #{aggregate_id}."
        end
    end
  end

  def get(aggregate_id) do
    GenServer.call(via(aggregate_id), :get)
  end

  ## GenServer callbacks
  def init(aggregate_id) do
    # TODO: load events from aggregate feed
    {:ok, %{aggregate_id: aggregate_id}}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
  def handle_call(function, _from, state) do
    case function.({state, []}) do
      {_state, {:error, _reason} = error} ->
        {:reply, error, state}
      {new_state, _new_events} ->
        # TODO: store events in aggregate feed
        {:reply, :ok, new_state}
    end
  end


  ## Private API
  defp via(aggregate_id) do
    {:via, Registry, {Registry.Aggregates, aggregate_id}}
  end



end
