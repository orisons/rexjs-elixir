defmodule Orisons.RexJS do
  @moduledoc false
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    children = [
      supervisor(Registry, [:unique, :rexjs_registry]),
      supervisor(Orisons.RexJS.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Orisons.RexJS]
    Supervisor.start_link(children, opts)
  end

end
