#!/usr/bin/env python
""#line:10
import os as O0OO0OOOO000O0000 #line:11
from preprocess import *#line:12
import pymysql as O0O0O0O0O0O00O000 #line:13
from ConfParser import ConfParser as OO0OOOO000OO0000O #line:14
from conndb import mysql as O0O0000O0OOOOOO00 #line:15
import numpy as OO00000OO00000OO0 #line:16
from sklearn .preprocessing import StandardScaler as OOO0OOOOOOOOOO000 #line:17
from sklearn .externals import joblib as O0OOOOO0OO0OOO0OO #line:18
import time as OOO0OO0OO00O0OO00 #line:19
from write2db import *#line:20
import json as O00000O0O0OOOOOOO #line:21
import sys as O00OOOOO0OOOO00O0 #line:22
import logging as OOO0OOOO0000O0OO0 #line:24
OOO0OOOO0000O0OO0 =__import__ ('logging.handlers',globals (),locals ())#line:25
info =OO0OOOO000OO0000O (O0OO0OOOO000O0000 .path .join (O0OO0OOOO000O0000 .path .abspath (O0OO0OOOO000O0000 .path .dirname (__file__ )),'dbServer.conf')).getValue ()#line:27
db =info ['db']#line:28
def predictRes (OOO0O0000OO0O0O0O ,**O0OO000OO00O0OO00 ):#line:31
    O0O000OOO00000OO0 =O0OO000OO00O0OO00 ['reading']#line:33
    OOOOO00OO000O0O0O =O0OO000OO00O0OO00 ['yongdian']#line:34
    OOOO0OOOOOO0O0O0O =O0OO000OO00O0OO00 ['xiansun']#line:35
    OO00O0OOOO0O0O0OO =O0OO000OO00O0OO00 ['huhao_taiqu']#line:36
    OO0OOOOO0O000O0OO =[O0000OO000O00OOOO for O0000OO000O00OOOO in OOOOO00OO000O0O0O if float (OOOOO00OO000O0O0O [O0000OO000O00OOOO ][-1 ])>0.01 ]#line:38
    _O0O00O0000OOOOOOO =OO00000OO00000OO0 .array ([[OO00000OO00000OO0 .mean (OO00000OO00000OO0 .array (O0O000OOO00000OO0 [OO000OOOO000O0OO0 ]))]+OOOOO00OO000O0O0O [OO000OOOO000O0OO0 ][1 :]+OOOO0OOOOOO0O0O0O [OO00O0OOOO0O0O0OO [OO000OOOO000O0OO0 ]]+[OO00000OO00000OO0 .mean (OO00000OO00000OO0 .array (OOOO0OOOOOO0O0O0O [OO00O0OOOO0O0O0OO [OO000OOOO000O0OO0 ]]))]for OO000OOOO000O0OO0 in OO0OOOOO0O000O0OO ])#line:41
    OO00OOOOOO0000O0O =OOO0OOOOOOOOOO000 ()#line:43
    OO00OOOOOO0000O0O .fit (_O0O00O0000OOOOOOO )#line:44
    OOOO0O0OO0000O00O =OO00OOOOOO0000O0O .transform (_O0O00O0000OOOOOOO )#line:45
    OO0000O0O00O0O000 =O0OOOOO0OO0OOO0OO .load (OOO0O0000OO0O0O0O )#line:47
    logger .info ("model load done")#line:48
    OOOO00O0000O0O00O =OO0000O0O00O0O000 .predict (OOOO0O0OO0000O00O )#line:50
    O0OOOO0000O0OO0OO =OO0000O0O00O0O000 .predict_proba (OOOO0O0OO0000O00O )#line:51
    O0OO0000O00O0000O ={}#line:53
    for O0OO0000O0O0O0O00 ,O0O000OOO00O0OO00 in enumerate (OO0OOOOO0O000O0OO ):#line:54
        O0OO0000O00O0000O [O0O000OOO00O0OO00 ]=(OOOO00O0000O0O00O [O0OO0000O0O0O0O00 ],O0OOOO0000O0OO0OO [O0OO0000O0O0O0O00 ][1 ])#line:55
    logger .info ("predict result outout done")#line:57
    return O0OO0000O00O0000O #line:59
def efilch_detect ():#line:61
        logger .info ("start efilch detecting")#line:65
        O0OOOO0000OO0O0O0 ,OOOOOO00OOO0OO00O ,O00OO0O0O0OOO0OOO =get_yongdian (dataPath )#line:66
        logger .info ("get formated elecconsume data done")#line:68
        global starttime ,endtime ,user_num ,zone_num #line:69
        starttime =O00OO0O0O0OOO0OOO [0 ]#line:70
        endtime =O00OO0O0O0OOO0OOO [1 ]#line:71
        user_num =len (O0OOOO0000OO0O0O0 )#line:72
        sql .truncate ('elecconsume')#line:75
        put_yongdian_2db (O0OOOO0000OO0O0O0 ,sql )#line:77
        logger .info ("power consume data write2db done")#line:78
        O0OO0O0OO000O0OO0 =get_xiansun (dataPath )#line:81
        logger .info ("get formated lineloss data done")#line:82
        O000O0OOOOO0O0O0O =get_HuHao2taiqu (dataPath )#line:83
        logger .info ("get formated id2zone data done")#line:84
        zone_num =len (set (O000O0OOOOO0O0O0O .values ()))#line:85
        OOOOOO000OOOO00O0 =get_sampleset (O0OOOO0000OO0O0O0 ,OOOOOO00OOO0OO00O ,O000O0OOOOO0O0O0O )#line:87
        logger .info ("get formated sampleset data done")#line:88
        OOO00OOO0O0O00000 ={}#line:89
        OOO00OOO0O0O00000 ['reading']=O0OOOO0000OO0O0O0 #line:90
        OOO00OOO0O0O00000 ['yongdian']=OOOOOO000OOOO00O0 #line:91
        OOO00OOO0O0O00000 ['xiansun']=O0OO0O0OO000O0OO0 #line:92
        OOO00OOO0O0O00000 ['huhao_taiqu']=O000O0OOOOO0O0O0O #line:93
        logger .info ("data load done")#line:95
        O0O000O0OOOO0OO00 =scriptPath +"train_model_MLP_.m"#line:98
        OO0O000OO00OO0O0O =predictRes (O0O000O0OOOO0OO00 ,**OOO00OOO0O0O00000 )#line:99
        return OO0O000OO00OO0O0O #line:101
def get_efilchuser ():#line:104
    OO00O0O0O0000O0OO =0 #line:105
    try :#line:106
        O0000O0OO0OO0O0OO =OOO0OO0OO00O0OO00 .clock ()#line:107
        OO00O0OOOO00O0000 =efilch_detect ()#line:108
    except Exception as OOOO0OOOOOO0O0000 :#line:109
        OO00O0O0O0000O0OO =-1 #line:111
        print (OO00O0O0O0000O0OO )#line:112
        return OO00O0O0O0000O0OO #line:113
    try :#line:115
        sql .truncate ('userinfo')#line:117
        put_userinfo_2db (sql ,dataPath )#line:118
        logger .info ("userinfo write2db done")#line:120
        logger .info ('detect process done')#line:122
        OO000O0O0O0O00000 ={OO0O0OO00OOOO0OO0 :float (O0O0000O0O0OOO000 [1 ])for OO0O0OO00OOOO0OO0 ,O0O0000O0O0OOO000 in OO00O0OOOO00O0000 .items ()if O0O0000O0O0OOO000 [0 ]==1 and float (O0O0000O0O0OOO000 [1 ])>0.6 }#line:123
        global thief_num #line:125
        thief_num =len (OO000O0O0O0O00000 )#line:126
        put_metadata_2db (starttime ,endtime ,zone_num ,user_num ,thief_num ,sql )#line:128
        logger .info ("metadata write2db done")#line:129
        put_detectres_2db (OO000O0O0O0O00000 ,sql )#line:132
        logger .info ('result write2db done')#line:134
        OO0O0OOOOOO00000O =OOO0OO0OO00O0OO00 .clock ()#line:136
        O0O000000OO0O0O00 =OO0O0OOOOOO00000O -O0000O0OO0OO0O0OO #line:137
        print (O0O000000OO0O0O00 )#line:138
        logger .info ("use time:"+str (O0O000000OO0O0O00 ))#line:140
    except Exception as OOOO0OOOOOO0O0000 :#line:142
        OO00O0O0O0000O0OO =-2 #line:143
        print (OO00O0O0O0000O0OO )#line:144
        return OO00O0O0O0000O0OO #line:145
    print (OO00O0O0O0000O0OO )#line:147
    return OO00O0O0O0000O0OO #line:148
sql =O0O0000O0OOOOOO00 (db ['host'],db ['user'],db ['pass'],db ['name'],int (db ['port']))#line:151
sql .connect ()#line:152
LOG_FILE ='javalog'#line:156
handler =OOO0OOOO0000O0OO0 .handlers .RotatingFileHandler (LOG_FILE ,maxBytes =1024 *1024 ,backupCount =5 )#line:157
fmt ='%(asctime)s - %(filename)s:%(lineno)s - %(name)s - %(levelname)s - %(message)s'#line:158
formatter =OOO0OOOO0000O0OO0 .Formatter (fmt )#line:159
handler .setFormatter (formatter )#line:160
logger =OOO0OOOO0000O0OO0 .getLogger ('tst')#line:162
logger .addHandler (handler )#line:163
logger .setLevel (OOO0OOOO0000O0OO0 .DEBUG )#line:164
starttime =''#line:167
endtime =''#line:168
user_num =0 #line:170
zone_num =0 #line:171
thief_num =0 #line:172
dataPath =O00OOOOO0OOOO00O0 .argv [1 ]#line:177
scriptPath ='D:/apache-tomcat-7.0.82/webapps/qdyhjc/scripts/'#line:179
get_efilchuser ()
#e9015584e6a44b14988f13e2298bcbf9