#encoding: utf-8
#/usr/bin/ruby

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

		if code.strip =~ /="\d{6}"/
			if (vol.to_f > 0) && (zf.to_f < 9.99) && (qjzf.to_f < 100) && (qsyjs0.to_f>0 || dyx0.to_f>0 || wyx0.to_f>0 || wtp0.to_f>0 || dtp1.to_f>0 || wtp1.to_f>0 || dtp2.to_f>0 || wtp2.to_f>0 || mkdjs0.to_f>0)
				# if mkdjs0.to_f > 0
				# if wtp1.to_f > 0
				# if wtp2.to_f > 0
				if wtp0.to_f > 0
					puts "#{date},#{code},#{name},#{zf},#{close},#{vol},#{amount},#{qsyjs0},#{dyx0},#{wyx0},#{wtp0},#{dtp1},#{wtp1},#{dtp2},#{wtp2},#{mkdjs0},#{sd},#{ed},#{to},#{tc},#{qjzf}"
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

puts ",代码,名称,涨幅%%,收盘,成交量,总金额,QSYJS0,DYX0,WYX0,WTP0,DTP1,WTP1,DTP2,WTP2,MKDJS0,SD,ED,TO,TC,QJZF"
dir_paths.each do |dir_path|
	deal_dir dir_path
end