defmodule Ip2regionEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args), do: Ip2regionEx.Supervisor.start_link([])

#  @impl true
#  def start(_type, _args) do
#    children = [
#      # Starts a worker by calling: Ip2regionEx.Worker.start_link(arg)
#      # {Ip2regionEx.Worker, arg}
#    ]
#
#    # See https://hexdocs.pm/elixir/Supervisor.html
#    # for other strategies and supported options
#    opts = [strategy: :one_for_one, name: Ip2regionEx.Supervisor]
#    Supervisor.start_link(children, opts)
#  end
end
