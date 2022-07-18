defmodule Ip2regionEx.Database  do

  alias Ip2regionEx.Database.Storage


  # ip: {a,b,c,d}
  def lookup(ip) do
    meta = Storage.get(:meta)    #  数据库描述
    data = Storage.get(:data)    #  数据区，去掉 headerIndex 和 index块的纯数据，开始偏移为 ptr : (16k +8) = 16392 = (0x4008)
    index = Storage.get(:index)  #  索引

    # result = %{city_id: city_id, content: content}
    case lookup_ip(ip, meta, index) do
      -1  -> nil
      {sip, eip, data_offset, data_len } = index_block ->
         # 从数据区，读取 city_id 和 ip 解析后内容
         { city_id, content }  = read_data_block(data_offset, data_len, data)
         %{ ip: ip , sip: int_to_ip(sip), eip: int_to_ip(eip), city_id: city_id, content: content  }
    end
  end


  # 返回 数据指针, 找不到 返回 -1
  # 参数  ip, meta, index
  defp lookup_ip(_, nil, nil), do: -1
  defp lookup_ip({a, b, c, d} = ip, meta, index ) do
    hi = meta.index_count  # 索引块数，每块 12 字节
    ip
    |> ip_to_int( )
    |> binsearch(  0, hi,  index)  # lo = 0, hi = 索引块数
  end


  #  ip(int) , lo,  hi , index
  defp  binsearch(_, lo, hi, _) when lo > hi, do: -1
  defp  binsearch(ip, lo, hi, index) do
    mid = div(lo + hi, 2)  # 中位数，indexBlock 块数
    offset = mid * 12

    # 移动到 offset 读取 12 字节
    {sip, eip, data_offset, data_len } = read_index_block(offset,index)

    if( sip <= ip  and ip <= eip) do    # 找到ip区间，返回 数据指针
       {sip, eip, data_offset, data_len }
    else
       if( sip > ip ) do    # hi = mid -1, lo 不变
         binsearch( ip, lo, mid - 1, index)
       else
         binsearch(ip, mid + 1, hi , index)
       end
    end
  end

  # 读取一个 indexBlock 12 字节
  def read_index_block( offset, index  ) do
        <<
           _skip :: binary-size(offset),
           a :: size(8), b :: size(8),c :: size(8),d :: size(8),
           e :: size(8), f :: size(8),g :: size(8),h :: size(8),
           data_ptr :: size(32),
           _ :: binary >> = index

        dot_sip = {d,c,b,a}
        int_sip = ip_to_int(dot_sip)

        dot_eip = {h,g,f,e}
        int_eip = ip_to_int(dot_eip)

        # 数据指针  16392 = 16k + 8 = 0x4008 , 为数据区第一个数据块
        <<ptr1 :: 8, ptr2 :: 8, ptr3 :: 8, data_len :: 8>> = <<data_ptr :: 32>>
        <<ptr :: 24>> = <<ptr3 :: 8, ptr2 :: 8, ptr1 :: 8>>

        # 读取数据区
        data_offset = ptr - 16392  # 相对数据区开始位置的偏移

        {int_sip, int_eip, data_offset, data_len }
  end

  # 读取一个数据块
  def read_data_block(data_offset, data_len, data)  do
        # 读取数据区
        content_size = data_len - 4  # 内容长度 = 长度 - 4字节(city_id)

        << _skip :: binary-size(data_offset),
          city_id :: little-size(32) ,
          content :: binary-size(content_size) ,
          _ :: binary
        >> = data

        {city_id, content }
  end



  # 0.255.255.255 ->     16777215
  # 10.0.3.193    ->    167773121
  def ip_to_int({a,b,c,d}) do
    << int_ip :: 32 >> = << a :: size(8), b :: size(8), c  :: size(8), d :: size(8) >>
    int_ip
  end
  def int_to_ip( int_ip ) do
    << a :: size(8), b :: size(8), c  :: size(8), d :: size(8) >>  = << int_ip :: 32>>
    {a,b,c,d}
  end


end