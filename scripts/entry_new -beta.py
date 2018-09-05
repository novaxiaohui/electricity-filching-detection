#!/usr/bin/env python
# encoding: utf-8
"""
Created on  2018/5/18 9:08

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
import random as rnd

import logging
import logging.handlers

from sklearn.preprocessing import StandardScaler
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import roc_curve, auc
from sklearn.model_selection import StratifiedKFold

from sklearn.externals import joblib

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



def efilch_detect(model_name):

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
        sql.truncate('diffconsume')  ### 先清空用户净用电量表 #####

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
        testDataset['yongdian'] = sample_set  #28239   //差分电量
        testDataset['xiansun'] = xiansun   #22351
        testDataset['huhao_taiqu'] = huhao_taiqu   #1171492  -> 138097

        logger.info("data load done")

        model_name='train_model_MLP_.m'
        modelFile = scriptPath + model_name
        res = predictRes(modelFile, **testDataset)

        return res



def get_efilchuser(model_name):
    ERROR_CODE = 0
    try:
        start = time.clock()
        res = efilch_detect(model_name)
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




def efilch_train(dataPath,modelPath):

        #### preprocess traindata##########

        logger.info("start efilch training")
        yongdian, ctpt,start_end = get_yongdian(dataPath)

        logger.info("get formated elecconsume data done")
        global starttime,endtime,user_num,zone_num
        starttime = start_end[0]
        endtime = start_end[1]
        user_num = len(yongdian)
        qiedian = get_qiedian(dataPath)
        xiansun = get_xiansun(dataPath)
        logger.info("get formated lineloss data done")
        huhao_taiqu = get_HuHao2taiqu(dataPath)
        logger.info("get formated id2zone data done")
        zone_num = len(set([huhao_taiqu[user] for user in yongdian if user in huhao_taiqu]))

        sample_set = get_sampleset_train(qiedian, yongdian, ctpt, huhao_taiqu)
        logger.info("get formated sampleset data done")
        testDataset = {}
        testDataset['reading'] = yongdian
        testDataset['yongdian'] = sample_set
        testDataset['xiansun'] = xiansun
        testDataset['huhao_taiqu'] = huhao_taiqu

        logger.info("data load done")


        sample = [item for item in testDataset['yongdian'] if float(yongdian[item][-1]) > 0.01]

        train_id = rnd.sample(sample,int(len(sample)*0.8))
        test_id = list(set(sample).difference(set(train_id)))
        train_x = np.array([[np.mean(np.array(testDataset['reading'][item]))] + testDataset['yongdian'][item][1:] + xiansun[huhao_taiqu[item]] \
                       +[np.mean(np.array(xiansun[huhao_taiqu[item]]))] for item in train_id])
        test_x = np.array([[np.mean(np.array(testDataset['reading'][item]))] + testDataset['yongdian'][item][1:] + xiansun[huhao_taiqu[item]] \
                       +[np.mean(np.array(xiansun[huhao_taiqu[item]]))] for item in test_id])

        train_y = np.array([1 if item in qiedian else 0 for item in train_id])
        test_y = np.array([1 if item in qiedian else 0 for item in test_id])


        scaler = StandardScaler()
        scaler.fit(train_x)
        train_x = scaler.transform(train_x)
        test_x = scaler.transform(test_x)

        clf = MLPClassifier(solver='lbfgs', alpha=1e-5, hidden_layer_sizes=(15, ), random_state=1)
        out = clf.fit(train_x, train_y).predict(test_x)
        probas_ = clf.fit(train_x, train_y).predict_proba(test_x)
        timestamp = int(time.time())
        model_name = "/train_model_MLP_"+timestamp+'.m'
        joblib.dump(clf, modelPath+model_name)
        logger.info("model train and store done")


        return model_name


def train_model():

    qiedian = load_data('qiediandata.txt')
    yongdian = load_data('yongdian_ganjing.txt')
    ctpt = load_data('ctpt.txt')
    xiansun = load_data('xiansun.txt')
    #xiansun = load_data('xiansun_withoutnegative.txt')
    huhao_taiqu = load_data('huhao_taiqu.txt', 0)
    # print(len(qiedian))
    # print(len(set(list(huhao_taiqu.keys())).intersection(set(list(yongdian.keys())))))
    # print(len(set(list(huhao_taiqu.keys())).intersection(set(list(qiedian.keys())))))

    qiedianWithxiansun = set(list(huhao_taiqu.keys())).intersection(set(list(qiedian.keys())))
    ganjingWithxiansun = set(list(huhao_taiqu.keys())).intersection(set(list(yongdian.keys())))

    sample = list(qiedianWithxiansun.union(ganjingWithxiansun))
    sample = [item for item in qiedianWithxiansun.union(ganjingWithxiansun) if huhao_taiqu[item][0] in xiansun]
    print(len(sample))
    train_id = rnd.sample(sample,int(len(sample)*0.8))
    test_id = list(set(sample).difference(set(train_id)))

    #采用了总功尖峰平谷的用电量,线损
    train_x = np.array([yongdian[item] + xiansun[huhao_taiqu[item][0]]if item in yongdian else qiedian[item] + xiansun[huhao_taiqu[item][0]] for item in train_id ])
    test_x = np.array([yongdian[item] + xiansun[huhao_taiqu[item][0]] if item in yongdian else qiedian[item] + xiansun[huhao_taiqu[item][0]] for item in test_id ])

    train_y = np.array([0 if item in yongdian else 1 for item in train_id])
    test_y = np.array([0 if item in yongdian else 1 for item in test_id])


    scaler = StandardScaler()
    scaler.fit(train_x)
    train_x = scaler.transform(train_x)
    test_x = scaler.transform(test_x)


    cv = StratifiedKFold(n_splits=6)
    #cv = StratifiedKFold(n_splits=6, shuffle=True)
    clf = MLPClassifier(solver='lbfgs', alpha=1e-5, hidden_layer_sizes=(15, ), random_state=1)

    mean_tpr = 0.0
    mean_fpr = np.linspace(0, 1, 100)

    colors = cycle(['cyan', 'indigo', 'seagreen', 'yellow', 'blue', 'darkorange'])
    lw = 2

    i = 0
    for (train, test), color in zip(cv.split(train_x, train_y), colors):
        out = clf.fit(train_x[train], train_y[train]).predict(train_x[test])
        probas_ = clf.fit(train_x[train], train_y[train]).predict_proba(train_x[test])
        # print(train)
        # print(np.where(out==1))
        # print(probas_)

        # for i in range(len(test)):
        #     print("%d\t%f\n" %(i, probas_[i]))
        # Compute ROC curve and area the curve
        fpr, tpr, thresholds = roc_curve(train_y[test], probas_[:, 1])
        mean_tpr += interp(mean_fpr, fpr, tpr)
        mean_tpr[0] = 0.0
        roc_auc = auc(fpr, tpr)
        plt.plot(fpr, tpr, lw=lw, color=color,
                 label='ROC fold %d (area = %0.2f)' % (i, roc_auc))

        i += 1

    paramsfile = '../图表/MLPclassifer_parameters'
    print(clf.coefs_)
    print(clf.intercepts_)
    #np.savetxt(paramsfile, clf.intercepts_)

    plt.plot([0, 1], [0, 1], linestyle='--', lw=lw, color='k',
             label='Luck')

    mean_tpr /= cv.get_n_splits(train_x, train_y)
    mean_tpr[-1] = 1.0
    mean_auc = auc(mean_fpr, mean_tpr)
    plt.plot(mean_fpr, mean_tpr, color='g', linestyle='--',
             label='Mean ROC (area = %0.2f)' % mean_auc, lw=lw)

    plt.xlim([-0.05, 1.05])
    plt.ylim([-0.05, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('electricity filching detection model for low voltage')
    plt.legend(loc="lower right")
    plt.show()

    joblib.dump(clf, "train_model_MLP_yongdian.m")


    count = 0



    print(count)


    print('done')




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

# dataPath = '../testData/'
dataPath = sys.argv[1]
#dataPath = 'D:/springUpload/admin/20171129_153101/'
scriptPath = 'C:/apache-tomcat-7.0.82/webapps/qdyhjc/scripts/'


train_model()
get_efilchuser()

