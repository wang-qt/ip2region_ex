use Mix.Config

ip2region_db = [ __DIR__, "../priv/data/ip2region.db" ] |> Path.join() |> Path.expand()
config :ip2region_ex,
       database: ip2region_db,
       pool: [ size: 5, max_overflow: 10 ]
