# RexJS - elixir

**RexJS is library for reactivity between elixir data with front-end through javascript websockets.**

## Installation

### Elixir
Add `rexjs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:rexjs, "~> 0.0.1"}]
end
```

### Front-end
* [JavaScript](https://www.google.com)
* [VueJS](https://www.google.com)

## Usage

### Phoenix Framework:
#### Add to ``config.ex``:
```elixir
config :rexjsphoenix, YourPhoenixApp.Endpoint,
  ...
  http: [dispatch: [
        {:_, [
            {"/rexjs", Orisons.RexJS.Adapter.Cowboy, []},
            {:_, Plug.Adapters.Cowboy.Handler, {YourPhoenixApp.Endpoint, []}}
          ]}]]
```
You can change ``"/rexjs"`` endpoint to other, it's configurable in front-end.

#### Start worker
```elixir
  Orisons.RexJS.Module.start_worker("worker_unique_name")
```

#### Set module data in worker
```elixir
  Orisons.RexJS.Module.set_data("worker_unique_name", "module_name", "Some value")
```
***This function post message with data to all binded websockets with this worker and module***

More info you can find in [documentation](https://www.google.com).