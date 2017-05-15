defmodule Estest.Commands do
  defmodule CreateCounter, do: defstruct [aggregate_id: nil, created: nil]
  defmodule IncrementCounter, do: defstruct [aggregate_id: nil, created: nil]
end
