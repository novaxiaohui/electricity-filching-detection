#!/usr/bin/env python
# encoding: utf-8
"""
Created on  2017/9/28 9:05

@author: Xiaohui 

Function: preprocess data

"""
import os
import csv
from itertools import islice
from datetime import datetime
from collections import defaultdict
from functools import reduce
import numpy as np



def get_ctpt(line, ctpt): # 提取 用户的ct pt 倍率，这里用户不区分是否窃电
    try:
        ctpt[line[2][:-1]] = [float(line[5]),float(line[6]),float(line[7])]
    except ValueError:
        ctpt[line[2][:-1]] = [float(1),  float(1), float(1)]

    return ctpt

def get_yongdian(path): # 用电数据，ct pt
    data = path + '\\低压抄表'
    filename = os.listdir(data)
    datelist = [datetime.strptime(item[:-4], '%Y-%m-%d') for item in filename]
    maxday = max(datelist)
    minday = min(datelist)

    days_num = 91   # default 跨期天数
    figures = {}
    ctpt= {}
    missing = defaultdict(int)
    for filetemp in filename:

        daytemp = maxday - datetime.strptime(filetemp[:-4], '%Y-%m-%d')
        daytempNum = 90 - daytemp.days
        if daytempNum < 0:
            continue
        file = csv.reader(open(data + '\\' + filetemp))
        for line in islice(file, 1, None):
            customer = line[2][:-1]
            figures.setdefault(customer, [0]*5*days_num) # 给每个用户初始化

            try:
                get_ctpt(line, ctpt)
                figures[customer][daytempNum] = float(line[16])
                figures[customer][days_num+daytempNum] = float(line[17])
                figures[customer][2*days_num+daytempNum] = float(line[18])
                figures[customer][3*days_num+daytempNum] = float(line[19])
                figures[customer][4*days_num+daytempNum] = float(line[20])

            except ValueError:
                missing[customer] += 1

    exception = []
    for customer in figures:
        if missing[customer] >= days_num/2:
            exception.append(customer)
    ###user count :34520   ####
    figures = {k:v for k,v in figures.items() if k not in exception}    #32757
    ctpt= {k:v for k,v in ctpt.items() if k not in exception}
    return figures, ctpt, [minday,maxday]



def get_HuHao2taiqu(path): # 户号和台区号对应，以便利用线损数据
    data = path + '\\对应关系'
    filename = os.listdir(data)
    huhao_taiqu = {} # {huhao1:taiqu1; }
    for item in filename:
        filesname = os.listdir(data+'\\'+ item)
        for filetemp in filesname:
            file = csv.reader(open(data + '\\' + item +'\\'+ filetemp))
            for line in islice(file, 1, None):

                huhao_index = line.index('户号')
                if '台区编码' in line:
                    taiqu_index = line.index('台区编码')
                elif '台区编号' in line:
                    taiqu_index = line.index('台区编号')
                else:
                    continue
                break
            try:
                for line in file:
                    huhao_taiqu[line[huhao_index]] = line[taiqu_index]
            except UnicodeDecodeError:
                continue

    ###1171492 pair for all
    return huhao_taiqu




def get_xiansun(path): # 台区线损数据
    data = path + '\\线损'
    filename = os.listdir(data)
    maxday = max([datetime.strptime(item[:-4], '%Y-%m-%d') for item in filename])
    days_num = 91   # 跨期天数
    figures = {}

    for filetemp in filename:
        daytemp = maxday - datetime.strptime(filetemp[:-4], '%Y-%m-%d')
        daytempNum = 90 - daytemp.days
        if daytempNum < 0:
            continue
        missing = {}
        file = csv.reader(open(data + '\\' + filetemp))
        for line in islice(file, 1, None):
            customer = line[2]
            figures.setdefault(customer,[0]*days_num) # 给每个用户初始化
            try:
                figures[customer][daytempNum] = float(line[4])
            except ValueError:
                missing.setdefault(customer,0)
                missing[customer] += 1
    ##22351 zone with lineloss
    return figures



def get_sampleset(yongdian, ctpt, huhao_taiqu):
    ganjingWithxiansun = set(list(huhao_taiqu.keys())).intersection(set(list(yongdian.keys())))

    thresh = 200000
    days_num = 91
    gap = days_num-1
    sample = []
    for item in list(ganjingWithxiansun):
            try:
                ttvalue = reduce(lambda x,y:x*y, ctpt[item])
            except KeyError:
                ttvalue = 1
            yongdian[item] = [ttvalue * _ for _ in yongdian[item]]
            if max(yongdian[item]) < thresh and any(yongdian[item]):   #     ####32350 user with lineloss ,then remove all zero sample
                sample.append(item)

    train_x = np.array([yongdian[item] for item in sample])

    sample_set = {}
    for i in range(len(train_x)):
        tempX = [0]*days_num*5
        for j in range(days_num-1):
            for k in range(5):
                if train_x[i][j+1 + days_num*k] < train_x[i][j + days_num*k]:
                    tempX[j + days_num * k] = train_x[i][j + 1 + days_num * k] - 0
                else:
                    tempX[j + days_num*k] = train_x[i][j+1 + days_num*k]-train_x[i][j + days_num*k]

        if max(tempX) > 500:
            continue
        else:
            tempX[days_num-1] = sum(tempX[:days_num-1])/gap
            tempX[days_num*2-1] = sum(tempX[days_num-1:days_num*2-1]) / gap
            tempX[days_num*3-1] = sum(tempX[days_num*2-1:days_num*3-1]) / gap
            tempX[days_num*4-1] = sum(tempX[days_num*3-1:days_num*4-1]) / gap
            tempX[days_num*5-1] = sum(tempX[days_num*4-1:days_num*5-1]) / gap

        sample_set[sample[i]] = [0] + tempX
    #####22351 user pass the day electricity consumption 500 threshold
    return sample_set

