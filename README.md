# Ip2regionEx

## 描述
[ip2region](https://github.com/lionsoul2014/ip2region)   - 是一个离线IP地址定位库和IP定位数据管理框架，10微秒级别的查询效率，提供了众多主流编程语言的 xdb 数据生成和查询客户端实现。
Ip2regionEx - 是ip2region v1.0 elixir语言客户端。使用 poolboy进程池，适用于高并发场景。

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
%{
  city_id: 166,
  content: "美国|0|0|0|Level3",
  eip: {8, 8, 8, 255},
  ip: {8, 8, 8, 8},
  sip: {8, 8, 8, 0}
}
iex(1)>  Ip2regionEx.lookup "211.161.240.90"
%{
  city_id: 995,
  content: "中国|0|上海|上海市|鹏博士",
  eip: {211, 161, 255, 255},
  ip: {211, 161, 240, 90},
  sip: {211, 161, 236, 0}
}
```

# Benchmarking

```elixir
iex(1)> :timer.tc(fn -> Ip2regionEx.lookup("8.8.8.8") end )
{150, %{ ... }}
iex(2)> :timer.tc(fn -> Ip2regionEx.lookup("211.161.240.90") end )
{152, %{ ... }}
```
