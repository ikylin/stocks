#encoding: utf-8
#/usr/bin/ruby

require 'spreadsheet'

# Spreadsheet.client_encoding = 'UTF-8'
Spreadsheet.client_encoding = 'GBK'

def deal_file file
	date = file.match(/\\([0-9_]*)\.xls/)[1].gsub(/_/,"-")
	# p file

	File.open(file,"r").each{ |line|
		cols = line.split("	")

		code = cols[0]#代码
		name = cols[1]#名称
		zf = cols[2]#涨幅%%
		close = cols[3]#收盘
		vol = cols[4]#成交量
		amount = cols[5]#总金额
		qsyjs0 = cols[6]#qsyjs0
		dyx0 = cols[7]#dyx0
		wyx0 = cols[8]#wyx0
		wtp0 = cols[9]#wtp0
		dtp1 = cols[10]#dtp1
		wtp1 = cols[11]#wtp1
		dtp2 = cols[12]#dtp2
		wtp2 = cols[13]#wtp2
		mkdjs0 = cols[14]#mkdjs0
		sd = cols[15]#sd
		ed = cols[16]#ed
		to = cols[17]#to
		tc = cols[18]#tc
		qjzf = cols[19]#qjzf

		if code.strip =~ /="\d{6}"/ && !(code.strip =~ /="300\d{3}"/)
			if (vol.to_f > 0) && (zf.to_f < 9.99) && (qjzf.to_f < 100) && (qsyjs0.to_f>0 || dyx0.to_f>0 || wyx0.to_f>0 || wtp0.to_f>0 || dtp1.to_f>0 || wtp1.to_f>0 || dtp2.to_f>0 || wtp2.to_f>0 || mkdjs0.to_f>0)

				# $data.row($datalineno).concat cols.insert(0,date)
				# $datalineno = $datalineno + 1

				if mkdjs0.to_f > 0
					# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
					$mkdjs0sheet.row($mkdjs0lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
					$mkdjs0lineno = $mkdjs0lineno + 1
				end
				# if wtp1.to_f > 0
				# 	# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
				# 	$wtp1sheet.row($wtp1lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
				# 	$wtp1lineno = $wtp1lineno + 1
				# end
				# if wtp2.to_f > 0
				# 	# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
				# 	$wtp2sheet.row($wtp2lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
				# 	$wtp2lineno = $wtp2lineno + 1
				# end
				# if wtp0.to_f > 0
				# 	# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
				# 	$wtp0sheet.row($wtp0lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
				# 	$wtp0lineno = $wtp0lineno + 1
				# end
				# if dtp1.to_f > 0
				# 	# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
				# 	$dtp1sheet.row($dtp1lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
				# 	$dtp1lineno = $dtp1lineno + 1
				# end
				# if dtp2.to_f > 0
				# 	# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
				# 	$dtp2sheet.row($dtp2lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
				# 	$dtp2lineno = $dtp2lineno + 1
				# end

				if wtp2.to_f > 0
					# puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
					$wtp2sheet.row($wtp2lineno).concat [date,code.match(/\d{6}/)[0],name,qjzf.to_f]
					$wtp2lineno = $wtp2lineno + 1
				end

			end
		end
	}
end

def deal_dir dir_path
	Dir.foreach dir_path do |file|
		if file != '.' && file != '..'
			deal_file "#{dir_path}#{file}"
			# break
		end
	end
end

dir_paths = ['..\\data\\0\\','..\\data\\1\\','..\\data\\2\\']
resultfile = "result.xls"

book = Spreadsheet::Workbook.new resultfile
# book = Spreadsheet.open resultfile
$datalineno = 1
$mkdjs0lineno = 0
$wtp1lineno = 0
$wtp2lineno = 0
$wtp0lineno = 0
$dtp1lineno = 0
$dtp2lineno = 0

$data = book.create_worksheet :name => "data"
$mkdjs0sheet = book.create_worksheet :name => "mkdjs0"
$wtp1sheet = book.create_worksheet :name => "wtp1"
$wtp2sheet = book.create_worksheet :name => "wtp2"
$wtp0sheet = book.create_worksheet :name => "wtp0"
$dtp1sheet = book.create_worksheet :name => "dtp1"
$dtp2sheet = book.create_worksheet :name => "dtp2"

# $data = book.worksheet "data"
# $mkdjs0sheet = book.worksheet "mkdjs0"
# $wtp1sheet = book.worksheet "wtp1"
# $wtp2sheet = book.worksheet "wtp2"
# $wtp0sheet = book.worksheet "wtp0"
# $dtp1sheet = book.worksheet "dtp1"
# $dtp2sheet = book.worksheet "dtp2"

# $data.row(0).concat  %w{date code name zf%% close vol amount QSYJS0 DYX0 WYX0 WTP0 DTP1 WTP1 DTP2 WTP2 MKDJS0 SD ED TO TC QJZF}
dir_paths.each do |dir_path|
	deal_dir dir_path
end
book.write resultfile
