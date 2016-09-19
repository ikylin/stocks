import re
import json

def get_mail_contents(file):
	
	file_object = open(file) 
	try: 
		list = {}
		for line in file_object: 
			item = {}
			cols = line.split('\t')
			if len(cols) > 2:
				m = re.match(r'=\"(\d+)\"', cols[0])
				if m != None:
					item['code'] = m.expand(r'\1')
					item['name'] = cols[1].strip()
					try:
						item['k'] = float(cols[6].strip())
						item['d'] = float(cols[7].strip())
						if (item['k'] < 20) and (item['d'] < 20):
							list[item['code']] = item
#							print("%s : %s - %k / %d" % (item['code'], item['name'], item['k'], item['d']) )
					except ValueError:
#						print('%s, %s' % (cols[6], cols[7]) )
						pass
	finally: 
		file_object.close() 

	#return json.dump(list, open(r'%s.json' % file, 'w'), indent=4)
	json.dump(list, open(r'%s.json' % file, 'w'), ensure_ascii=False, indent=4)

#get_mail_contents(r'c:\calc_2016-09-15_19-01-08.xls')
