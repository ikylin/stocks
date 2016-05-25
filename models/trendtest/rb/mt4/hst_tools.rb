# 安装bindata.gem
# SSL错误时
# set SSL_CERT_FILE=D:\dev\cacert.pem



# struct HistoryHeader { 
# int version; // 基础版本 
# char copyright[64]; // 版权信息 
# char symbol[12]; // 证券 
# int period; // 周期类型 
# int digits; // 小数位数 
# time_t timesign; // 基础报时的创建 
# time_t last_sync; // 同步时间 
# int unused[13]; // 将来应用 
# };

# 随后数据排列(一字节调整) 如下: 
# #pragma pack(push,1) 
# //---- 以常规报价代理为基础 
# struct RateInfo { 
# time_t ctm; // 以秒计算19700101到当前时间 
# double open; 
# double low; 
# double high; 
# double close; 
# double vol; }; 

require 'bindata'
require 'date'

# class HistoryHeader < BinData::Record
#   uint32le :version
#   string :copyright, :read_length => 64
#   string :symbol, :read_length => 12
#   uint32le :period
#   uint32le :digits
#   uint32le :timesign
#   uint32le :last_sync
#   string :unused, :read_length => 13*4
# end

# class RateInfo < BinData::Record
#   uint32le :ctm
#   float_le :unknown1
#   double_le :open
#   double_le :low
#   double_le :high
#   double_le :close
#   uint32le :vol
#   double_le :unknown2
#   double_le :unknown3
# end

# hstFile = "D:\\dev\\ruby\\mt4\\history\\EURCHFpro1440.hst"
# io = File.open(hstFile)
# hh = HistoryHeader.read(io)
# puts "HistoryHeader: version is #{hh.version}, copyright is #{hh.copyright}, symbol is #{hh.symbol}, period is #{hh.period}, digits is #{hh.digits}, timesign is #{Time.at(hh.timesign)}, last_sync is #{hh.last_sync}"


# def get_last_record io
# 	ri = nil
# 	while !io.eof do
# 		ri = RateInfo.read(io)
# 		# puts "ctm is #{Time.at(ri.ctm)}"

# 		# puts "ctm is #{Time.at(ri.ctm)}, open is #{ri.open}, low is #{ri.low}, high is #{ri.high}, close is #{ri.close}, vol is #{ri.vol}"
# 	end
# 	return ri
# end

# preri = get_last_record io


# puts "ctm is #{Time.at(preri.ctm)}, open is #{preri.open}, low is #{preri.low}, high is #{preri.high}, close is #{preri.close}, vol is #{preri.vol}"

# io.close


# 通达信日线*.day文件

# 文件名即股票代码
# 每32个字节为一天数据
# 每4个字节为一个字段，每个字段内低字节在前
# 00 ~ 03 字节：年月日, 整型
# 04 ~ 07 字节：开盘价*1000， 整型
# 08 ~ 11 字节：最高价*1000,  整型
# 12 ~ 15 字节：最低价*1000,  整型
# 16 ~ 19 字节：收盘价*1000,  整型
# 20 ~ 23 字节：成交额（元），float型
# 24 ~ 27 字节：成交量（手），整型
# 28 ~ 31 字节：上日收盘*1000, 整型

class TDXRecordDay < BinData::Record
  uint32le :date
  uint32le :open
  uint32le :high
  uint32le :low
  uint32le :close
  uint32le :amount
  uint32le :vol
  uint32le :reservation
end

# dayFile = "D:\\dev\\ruby\\mt4\\ds\\lday\\33#399001.day"
dayFile = "D:\\dev\\ruby\\mt4\\ds\\lday\\sz397002.day"
io = File.open(dayFile)

# 10.times {
# 	rd = TDXRecordDay.read(io)
# 	puts "TDXRecordDay: date is #{rd.date}, open is #{rd.open.to_f/100}, high is #{rd.high.to_f/100}, low is #{rd.low.to_f/100}, close is #{rd.close.to_f/100}, amount is #{rd.amount}, vol is #{rd.vol}, reservation is #{rd.reservation}"
# 	# puts "TDXRecordDay: date is #{rd.date}, open is #{rd.open.to_f/100}, high is #{rd.high/1000}, low is #{rd.low/1000}, close is #{rd.close/1000}, amount is #{rd.amount}, vol is #{rd.vol}, reservation is #{rd.reservation}"
# }

def get_last_record io
	rd = nil
	while !io.eof do
		rd = TDXRecordDay.read(io)
	end
	return rd
end
rd = get_last_record io
puts "TDXRecordDay: date is #{rd.date}, open is #{rd.open.to_f/100}, high is #{rd.high.to_f/100}, low is #{rd.low.to_f/100}, close is #{rd.close.to_f/100}, amount is #{rd.amount}, vol is #{rd.vol}, reservation is #{rd.reservation}"
# puts "TDXRecordDay: date is #{rd.date}, open is #{rd.open/1000}, high is #{rd.high/1000}, low is #{rd.low/1000}, close is #{rd.close/1000}, amount is #{rd.amount}, vol is #{rd.vol}, reservation is #{rd.reservation}"

io.close