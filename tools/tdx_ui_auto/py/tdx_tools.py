import pywinauto
import time
import logging

def check_for_uniq(name):
	logger = logging.getLogger()
	try:
		# app = pywinauto.application.Application().connect(path = r"C:\new_tdx\TdxW.exe")
		# main = app.window_(title_re = "通达信金融终端V7.*")
		# if main.取消.Exists():
		# 	main.取消.Click()
		# if main.Exists():
			
		# 	main.CloseAltF4()

		# 	qconfirm = app.window_(title_re = "退出确认")
		# 	# qconfirm.DrawOutline()
		# 	qconfirm.Wait("visible", timeout = 60)
		# 	qconfirm.退出.Click()
		# 	time.sleep(5)

		app = pywinauto.application.Application().start(r"C:\Windows\System32\taskmgr.exe")
		main = app.window_(title_re = ".*任务管理器")
		main.Tab1.Select(1)
		logger.info("check process.")
		while 1:
			try:
				main.ListView.GetItem(name).Select()
				main.Button1.Click()
				d = app.top_window_()
				d.结束进程.ClickInput()
				
				time.sleep(1)
			except Exception:
				logger.info("clear process successfully.")
				break
		main.CloseAltF4()
		time.sleep(5)
	except Exception:
		pass

		

#check_for_uniq("TdxW.exe")