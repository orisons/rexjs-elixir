defmodule Orisons.RexJS.Adapter.Cowboy do
    @moduledoc false
    
    import Logger

    alias Orisons.RexJS.Module

    def init(_, _req, _opts) do
        {:upgrade, :protocol, :cowboy_websocket}
    end

    @timeout 60000 # terminate if no activity for one minute

    def websocket_init(_type, req, opts) do
        {worker, _} = :cowboy_req.qs_val(<<"worker">>, req)
        {module, _} = :cowboy_req.qs_val(<<"module">>, req)
        state = %{
            pid: self(),
            worker: worker,
            module: module
        }

        Logger.info("[CONNECTED][PID: #{inspect state.pid}] worker: #{inspect state.worker}, module: #{inspect state.module}")

        Module.add_connection(state.worker, state.pid)
        send state.pid, :send_data

        {:ok, req, state, @timeout}
    end

    def websocket_info(:send_data, req, state) do
        case Module.get_data(state.worker, state.module) do
            {:error, message} -> 
                {:reply, {:text, %{"error": message} |> Poison.encode!}, req, state}
            data -> 
                {:reply, {:text, data |> Poison.encode!}, req, state}
        end

        # {:reply, {:text, message}, req, state}
    end

    def websocket_terminate(_reason, _req, state) do
        Module.delete_connection(state.worker, state.pid)
        Logger.info("[DISCONNECTED][PID: #{inspect state.pid}] worker: #{inspect state.worker}, module: #{inspect state.module}")
        :ok
    end
end