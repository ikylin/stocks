def deal_mx_file codeqr
	#权息明细查询
	# puts filename
	$file1 = "..\\data\\qx_year.txt"

	h_sum = {}
	File.open($file1,"r").each{ |line|
		cols = line.split("	")

		code = cols[0]

		name = cols[1]
		date = cols[2]
		songgu = cols[3].to_i
		fenhong = cols[4].to_f

		puts "#{date}\t#{songgu}\t#{fenhong}" if codeqr == code
	}
end

def deal_qx_file
	#全息明细合计
	# puts filename
	$file1 = "..\\data\\qx_year.txt"

	h_sum = {}
	File.open($file1,"r").each{ |line|
		cols = line.split("	")

		code = cols[0]

		name = cols[1]
		date = cols[2]
		songgu = cols[3].to_i
		fenhong = cols[4].to_f

		if h_sum[code].nil?
			item = {}
			item[:name] = name
			item[:songgu] = songgu
			item[:fenhong] = fenhong
			item[:date] = []
			item[:date] << date
		else
			item = h_sum[code]
			item[:songgu] = item[:songgu] + songgu
			item[:fenhong] =  item[:fenhong] + fenhong
			item[:date] << date
		end
		h_sum[code] = item
	}
	# puts h_sum["002545"]
	h_sum
end

def deal_cp_file
	#收盘价获取
	# puts filename
	$file1 = "..\\data\\沪深Ａ股20160127.txt"

	h_code = {}
	line_no = 0
	File.open($file1,"r").each{ |line|
		line_no = line_no + 1
		next if line_no == 1

		item = {}
		cols = line.split("	")

		code = cols[0]
		close = cols[3].to_f
		item[:close] = close
		pe = cols[15].to_f
		item[:pe] = pe
		hangye = cols[18]
		item[:hangye] = hangye
		ltgb = cols[28].to_f/10000
		item[:ltgb] = ltgb

		

		h_code[code] = item
	}
	h_code
end

def phb
	#股息排行榜计算
	h_sum = deal_qx_file
	h_code = deal_cp_file

	h_sum.each_key { |key|
		h_sum[key][:nhsy] = (10*h_sum[key][:fenhong])/h_code[key][:close] unless h_code[key].nil? || h_code[key][:close].nil? || h_code[key][:close].to_f == 0
	}

	h_sum_phb = Hash[h_sum.sort{|a, b| b[1][:nhsy] <=> a[1][:nhsy]}]
	# puts h_code
	print_phb h_sum_phb, h_code

	h_sum.each_key { |key|
		if h_code[key].nil? || h_code[key][:close].nil? || h_code[key][:close].to_f == 0 || h_sum[key][:songgu].nil? || h_sum[key][:songgu] == 0
			h_sum[key][:nhsy] = (10*h_sum[key][:fenhong])/h_code[key][:close]
		else
			h_sum[key][:nhsy] = (20+h_sum[key][:songgu])*(h_sum[key][:fenhong])/h_code[key][:close]/2
		end
	}

	h_sum_phb = Hash[h_sum.sort{|a, b| b[1][:nhsy] <=> a[1][:nhsy]}]
	print_phb h_sum_phb, h_code
end





def print_phb h_sum_phb, h_code
	i = 1
	h_sum_phb.each_key { |key|
		puts "#{i}\t#{key}\t#{h_sum_phb[key][:name]}\t#{h_sum_phb[key][:nhsy].round(2)}\t#{h_sum_phb[key][:fenhong].round(2)}\t#{h_sum_phb[key][:songgu]}\t#{h_code[key][:pe]}\t#{h_code[key][:hangye]}\t#{h_code[key][:ltgb]}\t#{h_sum_phb[key][:date].uniq.sort}"
		i = i + 1
		break if h_sum_phb[key][:nhsy] < 4
	}
	puts 
end


# deal_mx_file "002545"

# puts h_sum_phb


phb
