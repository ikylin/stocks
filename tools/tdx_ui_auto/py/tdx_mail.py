import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email import encoders
 
 
def sendmsg(subject, content, touser, files):
	msg=MIMEMultipart()  
	msg['from']='13611913741@139.com'  
	msg['to'] = touser
	msg['subject'] = subject
	# msg['subject']='test'  
	# content=''''' 
	#     你好， 
	#             这是一封自动发送的邮件。 
	 
	#         www.ustchacker.com 
	# '''  
	txt=MIMEText(content)  
	msg.attach(txt)  

	for file in files:
		basename = os.path.basename(file)
		fp = open(file, 'rb')
		att = MIMEText(fp.read(), 'base64', 'utf-8')
		att["Content-Type"] = 'application/octet-stream'
		#att["Content-Type"] = 'application/text'
		att.add_header('Content-Disposition', 'attachment',filename=('utf-8', '', basename))
		#encoders.encode_base64(att)
		msg.attach(att)
	  
	smtp=smtplib  
	smtp=smtplib.SMTP()  
	smtp.connect('smtp.139.com','25')  
	smtp.login('13611913741@139.com','zaqwsxcde123')  
	smtp.sendmail(msg['from'], msg['to'], str(msg))  
	#smtp.sendmail('13611913741@139.com', '12442835@qq.com', str(msg))  
	smtp.quit() 


# file = r'c:\calc_2016-09-15_19-01-08.xls'
# content = '''
# "000958": {
#         "name": "\u4e1c\u65b9\u80fd\u6e90",
#         "k": 14.367,
#         "code": "000958",
#         "d": 17.056
#     },
# '''
# sendmsg('test', content, r'%s.json' % file)