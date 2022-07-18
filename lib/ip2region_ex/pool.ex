defmodule Ip2regionEx.Pool  do
  def child_spec do
    opts = [
      name:          { :local, __MODULE__ },
      worker_module: Ip2regionEx.Server,
      size:          Application.get_env(:ip2region_ex, :pool)[:size] || 5,
      max_overflow:  Application.get_env(:ip2region_ex, :pool)[:max_overflow] || 10
    ]

    :poolboy.child_spec(__MODULE__, opts, [])
  end

end