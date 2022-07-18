defmodule Ip2regionEx do
  @moduledoc """
  Documentation for `Ip2regionEx`.
  """


  alias Ip2regionEx.Pool
  alias Ip2regionEx.Database.Loader

  #  手动加载数据库
  def load_database(filename) do
    GenServer.call(Loader, { :load_database, filename }, :infinity)
  end


  def lookup(ip) when is_binary(ip) do
    ip = String.to_charlist(ip)

    case :inet.parse_address(ip) do
      { :ok, parsed } -> lookup(parsed)
      { :error, _ }   -> nil
    end
  end

  # ip: {a,b,c,d}
  def lookup(ip) do
    :poolboy.transaction(Pool, &GenServer.call(&1, { :lookup, ip }))
  end


end
