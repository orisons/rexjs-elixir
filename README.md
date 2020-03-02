## DEPRECATED
This library is deprecated, please use [storex](https://github.com/nerdslabs/storex) instead.

# RexJS - elixir

[![Inline docs](http://inch-ci.org/github/orisons/rexjs-elixir.svg)](http://inch-ci.org/github/orisons/rexjs-elixir) [![Travis](https://travis-ci.org/orisons/rexjs-elixir.svg?branch=master)](https://travis-ci.org/orisons/rexjs-elixir)

**RexJS is library for reactivity between elixir data and front-end through javascript websockets.**



## Installation

### Elixir
Add `rexjs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:rexjs, "~> 0.1.0"}]
end
```

### Front-end
* [JavaScript](https://github.com/orisons/rexjs-javascript)
* [VueJS](https://github.com/orisons/rexjs-vue)

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

### Cowboy:
```elixir
:cowboy_router.compile([
  { :_,
    [
      {"/rexjs", Orisons.RexJS.Adapter.Cowboy, []}
      {"/someurl", DynamicPageHandler, []},
    ]
  }
])
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

More info you can find in [documentation](https://hexdocs.pm/rexjs/0.1.0/).
