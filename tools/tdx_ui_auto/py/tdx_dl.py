import pywinauto
import time
import logging
import tdx_tools

def download_data():
	logger = logging.getLogger()

	exe_path = r"C:\new_tdx\TdxW.exe"
	exe_name = "TdxW.exe"

	tdx_tools.check_for_uniq(exe_name)
	
	app = pywinauto.application.Application().start(exe_path)

	login = app.top_window_()

	login.Tab1.Select(1)
	# login.登录.Click()
	login.TypeKeys("{ENTER}")

	main = app.window_(title_re = "通达信金融终端V7.*")
	main.Wait("visible", timeout = 6000)

	time.sleep(3)
	tdxinfo = app.window_(title_re = "通达信信息")
	tdxinfo.Wait("visible", timeout = 6000)
	tdxinfo.Close()

	time.sleep(3)
	main['30'].Click()
	app.PopupMenu.Menu().GetMenuPath("盘后数据下载")[0].ClickInput()

	time.sleep(1)
	app.盘后数据下载.CheckBox.CheckByClick()
	time.sleep(1)
	app.盘后数据下载.Tab.Select(1)
	time.sleep(1)
	logger.info("开始下载行情数据")
	app.盘后数据下载.CheckBox2.CheckByClick()
	time.sleep(1)

	app.盘后数据下载.开始下载.Click()

	app.盘后数据下载.下载完毕.Wait("visible", timeout = 6000 * 60)
	logger.info("日线和5分钟数据下载完成")


	app.盘后数据下载.Tab.Select(0)
	time.sleep(1)
	app.盘后数据下载.CheckBox.UnCheck()
	time.sleep(1)
	app.盘后数据下载.Tab.Select(1)
	time.sleep(1)
	app.盘后数据下载.CheckBox2.UnCheck()

	time.sleep(1)
	app.盘后数据下载.Tab.Select(3)
	app.连接扩展市场行情主站.WaitNot("visible", timeout = 6000)
	app.盘后数据下载.CheckBox.CheckByClick()
	time.sleep(1)
	app.盘后数据下载.CheckBox2.CheckByClick()

	time.sleep(1)
	app.盘后数据下载.开始下载.Click()


	app.盘后数据下载.下载完毕.Wait("visible", timeout = 6000 * 60)
	logger.info("扩展市场数据下载完成")
	app.盘后数据下载.关闭.Click()

	time.sleep(3)

	main.CloseAltF4()

	qconfirm = app.window_(title_re = "退出确认")
	# qconfirm.DrawOutline()
	qconfirm.Wait("visible", timeout = 60)
	qconfirm.退出.Click()
	logger.info("数据下载完成,程序退出")


#download_data()