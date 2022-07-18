defmodule Ip2regionEx.Metadata  do

  defstruct [
    :file_len,      # 文件大小
    :buffer_len,    # 读取内存大小
    :super_block_first,   # 索引区开始地址
    :super_block_last,    # 最后一个索引地址
    :header_index,
    :header_index_len,
    :data,          # 数据区
    :data_bytes,      # 数据区字节数
    :index,         # 索引区域数据
    :index_bytes,     # 索引区域字节数
    :index_count    # 索引块个数
  ]

end