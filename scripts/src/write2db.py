#!/usr/bin/env python
# encoding: utf-8
"""
Created on  2017/9/29 8:55

@author: Xiaohui 

Function: preload data to database

"""
import os
import csv

from itertools import islice
from datetime import datetime
from collections import defaultdict
from ConfParser import ConfParser
from conndb import mysql
import traceback
from preprocess import *
import json

info = ConfParser(os.path.join(os.path.abspath(os.path.dirname(__file__)),'dbServer.conf')).getValue()
db = info['db']



def put_userinfo_2db( sql,path= '../testdata/'): # 用户基本信息入库
    data = path + '\\低压抄表'
    filename = os.listdir(data)

    userlist = {}

    for filetemp in filename:
        file = csv.reader(open(data + '\\' + filetemp))
        param = []
        try:
            for line in islice(file, 1, None):

                user_id = line[2][:-1].encode('utf-8')
                if user_id not in userlist:
                    userlist[user_id] = 1
                    user_name = line[3].encode('utf-8')
                    address = line[4].encode('utf-8')
                    station = line[1].encode('utf-8')
                    zone_name = line[12].encode('utf-8')
                    param.append((user_id,user_name,address,zone_name,station))

            sql.additem('userinfo(user_id,user_name,address,zone_name,station)',param, format='(%s,%s,%s,%s,%s)')

        except ValueError:
            traceback.print_exc()
            continue

    #### # of  user :34520

def put_yongdian_2db(figures, sql): # 用户用电量入库
    try:
        param = []
        for user_id in figures:


                elec_values = ','.join(map(str,figures[user_id][:90]))
                diff_values = ','.join(map(str,reduce(lambda x,y:y-x,  figures[user_id][:91])))
                param.append((user_id,elec_values))

        sql.additem('elecconsume(user_id,elec_value)',param, format='(%s,%s)')
        sql.additem('diffconsume(user_id,diff_value)',param, format='(%s,%s)')



    except ValueError:
        traceback.print_exc()
        #### # of  user :34520

def put_detectres_2db(efilch_res, sql): # 检测结果入库
    sql.truncate('detectres')  ### 先清空结果表 #####

    # efilch_res = {['3713505700',0.9],['3718012008',0.8],['3720049637',0.7],['3717057052',0.6]}
    param = [(x[0],x[1]) for x in efilch_res.items()]

    try:

                sql.additem('detectres(user_id,prop)',param, format='(%s,%s)')
    except ValueError:
                traceback.print_exc()


def put_metadata_2db(starttime,endtime,zone_num,user_num,thief_num,sql): #源数据信息入库

    try:
        sql.additem('metatable(start_time,end_time,zone_num,user_num,thief_num )',[(starttime, endtime,zone_num,user_num,thief_num)],\
                    format='(%s,%s,%s,%s,%s)')

    except ValueError:
        traceback.print_exc()



