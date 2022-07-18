defmodule Ip2regionEx.Supervisor do
  use Supervisor

  alias Ip2regionEx.Pool
  alias Ip2regionEx.Database.Loader

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    import Supervisor.Spec


    options = [ strategy: :one_for_one]
    children = [
      Pool.child_spec,
      supervisor(Ip2regionEx.Database.Supervisor, [])
    ]

    #    Supervisor.start_link(children, options)
    Supervisor.init(children, options)
  end


end