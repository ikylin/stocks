import pywinauto
import time
import tdx_tools

def gen_signal_file(file):
	exe_path = r"C:\new_tdx\TdxW.exe"
	exe_name = "TdxW.exe"

	tdx_tools.check_for_uniq(exe_name)

	
	app = pywinauto.application.Application().start(exe_path)

	login = app.top_window_()

	login.Tab1.Select(1)
	# login.登录.Click()
	login.TypeKeys("{ENTER}")

	main = app.window_(title_re = "通达信金融终端V7.*")
	main.Wait("visible", timeout = 6000 * 3)

	time.sleep(2)
	tdxinfo = app.window_(title_re = "通达信信息")
	tdxinfo.Wait("visible", timeout = 6000 * 1)
	if tdxinfo.Exists():
		tdxinfo.Close()

	# main.DrawOutline()
	time.sleep(3)
	main = app.window_(title_re = "通达信金融终端V7.*")
	main.TypeKeys("{.}{4}{0}{1}{ENTER}")

	time.sleep(1)
	update = app.window_(title_re = "刷新数据")
	# update.DrawOutline()
	update.WaitNot("visible", timeout = 6000 * 5)

	time.sleep(1)
	#calc = app.window_(title_re = "正在计算,请稍等.*")
	#cb = calc.取消
	#cb.DrawOutline()
	#calc.WaitNot("visible")
	app.WaitCPUUsageLower(15, timeout = 6000 * 60)

	time.sleep(1)
	main = app.window_(title_re = "通达信金融终端V7.*")
	main.TypeKeys("{3}{4}{ENTER}")

	time.sleep(1)
	export = app.window_(title_re = "数据导出")
	# export.DrawOutline()
	export.Tab1.Select(1)
	time.sleep(1)
	export.报表中所有数据.Click()

	# export.Edit.DrawOutline()
	time.sleep(1)
	export.Edit.SetText(file)
	#export.Edit.SetText('c:\\1.xls')
	time.sleep(1)
	export.导出.Click()

	time.sleep(1)
	confirm = app.window_(title_re = "TdxW")
	if not confirm.Exists():
		confirm.Wait("visible", timeout = 6000 * 3)
	confirm.取消.Click()



	time.sleep(3)
	main.CloseAltF4()

	qconfirm = app.window_(title_re = "退出确认")
	if qconfirm.Exists():
		qconfirm.Wait("visible", timeout = 6000 * 1)
	# qconfirm.DrawOutline()
	qconfirm.退出.Click()



#file = r"c:/calc_%s.xls" % "2"
#gen_signal_file(file)