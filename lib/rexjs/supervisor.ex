defmodule Orisons.RexJS.Supervisor do
    @moduledoc false
    use Supervisor

    @name Orisons.RexJS.Supervisor

    def start_link do
        Supervisor.start_link(__MODULE__, :ok, name: @name)
    end

    def init(:ok) do
        children = [
            worker(Orisons.RexJS.Module, [], restart: :transient)
        ]

        supervise(children, strategy: :simple_one_for_one)
    end

end