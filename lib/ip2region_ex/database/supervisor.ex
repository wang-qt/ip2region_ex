defmodule Ip2regionEx.Database.Supervisor do
  use Supervisor

  alias Ip2regionEx.Database

  def start_link(default \\ []) do
    Supervisor.start_link(__MODULE__, default)
  end

  def init(_default) do
    database = Application.get_env(:ip2region_ex, :database, [])
    children = [
      worker(Database.Storage, []),

      worker(Database.Loader, [database])
    ]

    supervise(children, strategy: :one_for_all)
  end
end