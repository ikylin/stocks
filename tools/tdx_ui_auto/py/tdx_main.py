#coding=utf-8

from apscheduler.schedulers.blocking import BlockingScheduler
from datetime import datetime
import time
import os
import logging

import tdx_mail
import tdx_calc
import tdx_pr
import tdx_dl

# logging.basicConfig(level=logging.DEBUG,  
#                     format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',  
#                     datefmt='%a, %d %b %Y %H:%M:%S') 

logger = logging.getLogger()
fh = logging.FileHandler(r'c:\robot.log')
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')  
fh.setFormatter(formatter)
logger.addHandler(fh)

def calc_signals():
    # print('Tick! The time is: %s' % datetime.now())
    tousers = ['12442835@qq.com']
    #tousers = ['610379749@qq.com','12442835@qq.com']
    files = []
    #timestr = '2016-09-15_19-01-08'
    timestr = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    file = r"c:/calc_%s.xls" % timestr
    files.append(file)
    jsonfile = r'%s.json' % file
    files.append(jsonfile)

    tdx_calc.gen_signal_file(file)
    logger.info("tdx_calc.gen_signal_file(%s)" % file)
    
    tdx_pr.get_mail_contents(file)
    logger.info("tdx_pr.get_mail_contents(%s)" % jsonfile)
    mail_content = open(jsonfile).read()
    #print(mail_content)
    for user in tousers:
        tdx_mail.sendmsg(r"Robot_tdx_%s" % timestr, mail_content, user, files)
        logger.info("tdx_mail.sendmsg(%s)" % user)

if __name__ == '__main__':
    #calc_signals()



    scheduler = BlockingScheduler()
#    scheduler.add_job(tick,'cron', minute='*/30', hour='9-12,13-15')
    #scheduler.add_job(tdx_dl.download_data,'cron', hour='17', week='0-4')    
    scheduler.add_job(tdx_dl.download_data,'cron', minute='0', hour='17')

    scheduler.add_job(calc_signals,'cron', minute='0', hour='10-11,13-15')
    #scheduler.add_job(calc_signals,'cron', second='*/30', minute='0-59', hour='9-12,13-15', week='0-4')
    print('Press Ctrl+{0} to exit'.format('Break' if os.name == 'nt' else 'C'))
    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown() 