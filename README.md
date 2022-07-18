# Ip2regionEx

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ip2region_ex` to your list of dependencies in `mix.exs`:

```elixir
def application do
  [applications: [:ip2region_ex]]
end

def deps do
  [
    {:ip2region_ex, github: "wang-qt/ip2region_ex"},
  ]
end
```
# Configuration

Add the path of the ip2region database to your project's configuration:

```elixir
use Mix.Config

ip2region_db = [ __DIR__, "../priv/data/ip2region.db" ] |> Path.join() |> Path.expand()
config :ip2region_ex,
       database: ip2region_db,
       pool: [ size: 5, max_overflow: 10 ]
```


# Usage

```elixir
iex(1)> Ip2regionEx.lookup("8.8.8.8")
%{ ... }
iex(1)> iex(1)> Ip2regionEx.lookup "211.161.240.90"
% { ... }
```

# Benchmarking

```elixir
iex(1)> :timer.tc(fn -> Ip2regionEx.lookup("8.8.8.8") end )
{150, %{ ... }}
iex(2)> :timer.tc(fn -> Ip2regionEx.lookup("211.161.240.90") end )
{152, %{ ... }}
```
