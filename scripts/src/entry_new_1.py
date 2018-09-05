#!/usr/bin/env python
# encoding: utf-8
"""
Created on  2017/9/28 9:08

@author: Xiaohui 

Function: Energy Filching Detection entrance

"""
import os
from preprocess import *
import pymysql
from ConfParser import ConfParser
from conndb import mysql
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.externals import joblib
import time
from write2db import *
import json
import sys

import logging
import logging.handlers

info=ConfParser(os.path.join(os.path.abspath(os.path.dirname(__file__)),'dbServer.conf')).getValue()
db = info['db']


def predictRes(modelFile, **kwargs):

    reading = kwargs['reading']
    yongdian = kwargs['yongdian']
    xiansun = kwargs['xiansun']
    huhao_taiqu = kwargs['huhao_taiqu']

    sample = [item for item in yongdian if float(yongdian[item][-1]) > 0.01]

    _x = np.array([[np.mean(np.array(reading[item]))] + yongdian[item][1:] + xiansun[huhao_taiqu[item]] \
                   +[np.mean(np.array(xiansun[huhao_taiqu[item]]))] for item in sample])

    scaler = StandardScaler()
    scaler.fit(_x)
    test_x = scaler.transform(_x)

    clf = joblib.load(modelFile)
    logger.info("model load done")

    flag = clf.predict(test_x)
    probas_ = clf.predict_proba(test_x)

    resDic = {}
    for no, ele in enumerate(sample):
        resDic[ele] = (flag[no], probas_[no][1])

    logger.info("predict result outout done")

    return resDic

def efilch_detect():

    #### preprocess testdata##########

        logger.info("start efilch detecting")
        yongdian, ctpt,start_end = get_yongdian(dataPath)

        logger.info("get formated elecconsume data done")
        global starttime,endtime,user_num,zone_num
        starttime = start_end[0]
        endtime = start_end[1]
        user_num = len(yongdian)

        ########       TO DO: put  yongdian data to database   ####################
        sql.truncate('elecconsume')  ### 先清空用户用电量表 #####

        put_yongdian_2db(yongdian,sql)
        logger.info("power consume data write2db done")

        ###########################################################################
        xiansun = get_xiansun(dataPath)
        logger.info("get formated lineloss data done")
        huhao_taiqu = get_HuHao2taiqu(dataPath)
        logger.info("get formated id2zone data done")
        zone_num = len(set([huhao_taiqu[user] for user in yongdian if user in huhao_taiqu]))

        sample_set = get_sampleset(yongdian, ctpt, huhao_taiqu)
        logger.info("get formated sampleset data done")
        testDataset = {}
        testDataset['reading'] = yongdian   #32757
        testDataset['yongdian'] = sample_set  #28239
        testDataset['xiansun'] = xiansun   #22351
        testDataset['huhao_taiqu'] = huhao_taiqu   #1171492  -> 138097

        logger.info("data load done")


        modelFile = scriptPath+"train_model_MLP_.m"
        res = predictRes(modelFile, **testDataset)

        return res


def get_efilchuser():
    ERROR_CODE = 0
    try:
        start = time.clock()
        res = efilch_detect()
    except Exception as e:

        ERROR_CODE = -1
        print(ERROR_CODE)
        return ERROR_CODE

    try:

        sql.truncate('userinfo')  ### 先清空用户信息表 #####
        put_userinfo_2db(sql, dataPath)

        logger.info("userinfo write2db done")

        logger.info('detect process done')
        efilch_res = {k: float(v[1]) for k, v in res.items() if v[0] == 1 and float(v[1])>0.6}

        global thief_num
        thief_num = len(efilch_res)

        put_metadata_2db(starttime,endtime,zone_num,user_num,thief_num, sql)
        logger.info("metadata write2db done")


        put_detectres_2db(efilch_res,sql)

        logger.info('result write2db done')

        end = time.clock()
        escaped = end - start
        print(escaped)

        logger.info("use time:" + str(escaped))

    except Exception as e:
        ERROR_CODE = -2
        print(ERROR_CODE)
        return ERROR_CODE
    # return efilch_res
    print(ERROR_CODE)
    return ERROR_CODE


sql=mysql(db['host'], db['user'], db['pass'], db['name'], int(db['port']))
sql.connect()


############## config log #################################
LOG_FILE = 'javalog'
handler = logging.handlers.RotatingFileHandler(LOG_FILE, maxBytes = 1024*1024, backupCount = 5) # 实例化handler
fmt = '%(asctime)s - %(filename)s:%(lineno)s - %(name)s - %(levelname)s - %(message)s'
formatter = logging.Formatter(fmt)   # 实例化formatter
handler.setFormatter(formatter)      # 为handler添加formatter

logger = logging.getLogger('tst')    # 获取名为tst的logger
logger.addHandler(handler)           # 为logger添加handler
logger.setLevel(logging.DEBUG)

####### global meta info ###############################
starttime = ''
endtime = ''

user_num = 0
zone_num = 0
thief_num = 0

#########################################################

#dataPath = '../testData/'
dataPath = sys.argv[1]
#dataPath = 'D:/springUpload/admin/20171129_153101/'
scriptPath = 'C:/apache-tomcat-7.0.82/webapps/qdyhjc/scripts/'

get_efilchuser()

