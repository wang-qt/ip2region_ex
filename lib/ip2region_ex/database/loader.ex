defmodule Ip2regionEx.Database.Loader do
  use GenServer

  alias Ip2regionEx.Database.Storage

  @bytes_16k   16 * 1024

  def start_link(filename \\ []) do
    GenServer.start_link(__MODULE__, filename, name: __MODULE__)
  end

  def init(filename) do
    load_database(filename)
    { :ok, %{ database: filename } }
  end

  def handle_call({ :load_database, filename }, _, state) do
    case load_database(filename) do
      :ok   -> { :reply, { :ok, filename }, %{ state | database: filename } }
      error -> { :reply, error, %{ state | database: filename } }
    end
  end


  defp load_database(database) do
    case File.regular?(database) do
      false -> { :error, "File '#{database}' does not exists!" }
      true ->
        database
        |> read_database()
        |> save_data()
    end
  end

  defp read_database(filename) do
    raw_data = File.read!(filename)

    <<super_block_first     :: little-size(32),
      super_block_last      :: little-size(32) ,
      _header_index         :: binary-size(@bytes_16k), # 跳过 16k字节
      rest                  :: binary >> = raw_data

    data_len = super_block_first - @bytes_16k - 8

    << data :: binary-size(data_len),
       index :: binary >> = rest


    {:ok, stat} = File.stat(filename)

    # %Ip2RegionEx.Metadata{
    #  buffer_len: 8733094,
    #  data: nil,
    #  data_len: 513576,
    #  file_len: 8733094,
    #  header_index: nil,
    #  header_index_len: nil,
    #  index: nil,
    #  index_count: 683591,
    #  index_len: 8203092,
    #  super_block_first: 529968,    # 0x81630 : 00000000 FFFFFF00 0840001B
    #  super_block_last: 8733048
    #}
    meta = %Ip2regionEx.Metadata{
      file_len: stat.size,
      buffer_len: byte_size(raw_data),
      super_block_first: super_block_first,
      super_block_last: super_block_last,
      data_bytes: data_len,
      index_bytes: super_block_last - super_block_first + 12,
      index_count:  div(super_block_last + 12 - super_block_first, 12)  ,
    }
    IO.inspect  meta

    # 返回 meta, 数据区，索引区
    { meta, data , index}
  end

  defp save_data({ meta, data, index }) do
    Storage.set(:meta, meta)
    Storage.set(:data, data)
    Storage.set(:index, index)

    :ok
  end


end