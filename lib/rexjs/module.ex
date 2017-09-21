defmodule Orisons.RexJS.Module do
    @moduledoc """
    With this module you can set and get data from specific worker and module.
    """
    use GenServer

    @supervisor_name Orisons.RexJS.Supervisor

    require Logger

    @doc false
    @spec via_tuple(id :: String.t) :: any
    def via_tuple(id) do
        {:via, Registry, {:rexjs_registry, id}}
    end

    @doc """
    Start 'worker' with unique `id`

    ## Examples

        iex> Orisons.RexJS.Module.start_worker("unique_worker_name")

    """
    @spec start_worker(id :: String.t) :: any
    def start_worker(id) do
        Supervisor.start_child(@supervisor_name, [id])
    end

    @doc """
    Stop 'worker' with unique `id`

    ## Examples

        iex> Orisons.RexJS.Module.stop_worker("unique_worker_name")

    """
    @spec stop_worker(id :: String.t) :: any
    def stop_worker(id) do
        Orisons.RexJS.Module.stop(id)
    end

    @doc """
    Set data for 'module' in 'worker'

    ## Examples

        iex> Orisons.RexJS.Module.set_data("unique_worker_name", "unique_module_name", "test data")

    """
    @spec set_data(id :: String.t, module :: String.t, data :: any) :: any
    def set_data(id, module, data) do
        GenServer.cast(via_tuple(id), {:set_data, module, data})
    end
    
    @doc """
    Get data from 'module' in 'worker'

    ## Examples

        iex> Orisons.RexJS.Module.get_data("unique_worker_name", "unique_module_name")
        "test data"

    """
    @spec get_data(id :: String.t, module :: String.t) :: any
    def get_data(id, module) do
        case GenServer.whereis(via_tuple(id)) do
            nil -> {:error, "Worker '#{id}' not started"}
            _   -> GenServer.call(via_tuple(id), {:get_data, module})
        end
    end

    @doc """
    Add websocket connection to 'worker'

    ## Examples

        iex> Orisons.RexJS.Module.add_connection("unique_worker_name", websocket_pid)

    """
    @spec add_connection(id :: String.t, connection :: pid) :: :ok
    def add_connection(id, connection) do
        GenServer.cast(via_tuple(id), {:add_connection, connection})
    end

    @doc """
    Remove websocket connection from 'worker'

    ## Examples

        iex> Orisons.RexJS.Module.delete_connection("unique_worker_name", websocket_pid)

    """
    @spec delete_connection(id :: String.t, connection :: pid) :: :ok
    def delete_connection(id, connection) do
        GenServer.cast(via_tuple(id), {:delete_connection, connection})
    end

    @doc false
    def start_link(id) do
        Logger.info("[WORKER][PID: #{inspect self()}][ID: #{inspect id}] Started")
        GenServer.start_link(__MODULE__, id, name: via_tuple(id))
    end

    @doc false
    def stop(id) do
        GenServer.stop(via_tuple(id))
    end

    def init(_) do
        {:ok, %{
            connections: [],
            data: %{}
        }}
    end

    def handle_cast({:add_connection, connection_pid}, state) do
        connections = Map.get(state, :connections)
        connections = [connection_pid | connections]
        state       = Map.put(state, :connections, connections)
        {:noreply, state}
    end

    def handle_cast({:delete_connection, connection_pid}, state) do
        connections = Map.get(state, :connections)
        connections = List.delete(connections, connection_pid)
        state       = Map.put(state, :connections, connections)
        {:noreply, state}
    end

    def handle_cast({:set_data, module, new_data}, state) do
        state = state
            |> Map.get(:data)
            |> Map.put(module, new_data)
            |> (&Map.put(state, :data, &1)).()
        
        Enum.each(state.connections, fn(x) -> 
            send x, :send_data
        end)

        {:noreply, state}
    end

    def handle_call({:get_data, module}, _from, state) do
        case Map.get(state.data, module) do
            nil         -> {:reply, {:error, "Module '#{module}' not exists"}, state}
            module_data -> {:reply, module_data, state}
        end
    end
end