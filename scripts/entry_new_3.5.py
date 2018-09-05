#!/usr/bin/env python
""#line:10
import os as O000OOOOOO0OO000O #line:11
from preprocess import *#line:12
import pymysql as OOOOOO0OO0000OOO0 #line:13
from ConfParser import ConfParser as O000OOOO0O0OOOO0O #line:14
from conndb import mysql as O0000OO00O0000O0O #line:15
import numpy as O00O0O000000O0O00 #line:16
from sklearn .preprocessing import StandardScaler as OOOOOOO000000OOOO #line:17
from sklearn .externals import joblib as OOOO0O0O0000OOOOO #line:18
import time as O0OO0OO0OO0O0O000 #line:19
from write2db import *#line:20
import json as O0OO00OOOOOO0O00O #line:21
import sys as O00OOO0OO000000O0 #line:22
import logging as O0OO0OO00O0O0O0OO #line:24
O0OO0OO00O0O0O0OO =__import__ ('logging.handlers',globals (),locals ())#line:25
info =O000OOOO0O0OOOO0O (O000OOOOOO0OO000O .path .join (O000OOOOOO0OO000O .path .abspath (O000OOOOOO0OO000O .path .dirname (__file__ )),'dbServer.conf')).getValue ()#line:27
db =info ['db']#line:28
def predictRes (OOO0OO00O0OO0O0OO ,**O0O000OO00OO0O00O ):#line:31
    OOOO0O000OO0000OO =O0O000OO00OO0O00O ['reading']#line:33
    OOOOOO00000000O0O =O0O000OO00OO0O00O ['yongdian']#line:34
    O000000O0OO00OO0O =O0O000OO00OO0O00O ['xiansun']#line:35
    O00O0O0O00OOOOOO0 =O0O000OO00OO0O00O ['huhao_taiqu']#line:36
    OO000O0000OO0000O =[O00O0000OO00OO000 for O00O0000OO00OO000 in OOOOOO00000000O0O if float (OOOOOO00000000O0O [O00O0000OO00OO000 ][-1 ])>0.01 ]#line:38
    _O0O00OO00O0O0O000 =O00O0O000000O0O00 .array ([[O00O0O000000O0O00 .mean (O00O0O000000O0O00 .array (OOOO0O000OO0000OO [OO00OO0O0O0OO00OO ]))]+OOOOOO00000000O0O [OO00OO0O0O0OO00OO ][1 :]+O000000O0OO00OO0O [O00O0O0O00OOOOOO0 [OO00OO0O0O0OO00OO ]]+[O00O0O000000O0O00 .mean (O00O0O000000O0O00 .array (O000000O0OO00OO0O [O00O0O0O00OOOOOO0 [OO00OO0O0O0OO00OO ]]))]for OO00OO0O0O0OO00OO in OO000O0000OO0000O ])#line:41
    O0OO00O000OO00000 =OOOOOOO000000OOOO ()#line:43
    O0OO00O000OO00000 .fit (_O0O00OO00O0O0O000 )#line:44
    O0000O00O000OOOOO =O0OO00O000OO00000 .transform (_O0O00OO00O0O0O000 )#line:45
    O00O000OOO0OO0000 =OOOO0O0O0000OOOOO .load (OOO0OO00O0OO0O0OO )#line:47
    logger .info ("model load done")#line:48
    OO000O000OOO0OOOO =O00O000OOO0OO0000 .predict (O0000O00O000OOOOO )#line:50
    OO00OOOO0000000O0 =O00O000OOO0OO0000 .predict_proba (O0000O00O000OOOOO )#line:51
    OOO0O000OOOO00OOO ={}#line:53
    for O00O0O0O0O000OO0O ,OO0O0O0OOO0O0O0O0 in enumerate (OO000O0000OO0000O ):#line:54
        OOO0O000OOOO00OOO [OO0O0O0OOO0O0O0O0 ]=(OO000O000OOO0OOOO [O00O0O0O0O000OO0O ],OO00OOOO0000000O0 [O00O0O0O0O000OO0O ][1 ])#line:55
    logger .info ("predict result outout done")#line:57
    return OOO0O000OOOO00OOO #line:59
def efilch_detect ():#line:61
        logger .info ("start efilch detecting")#line:65
        OO0O0000OO0OO00O0 ,O0O0OOO00000OOO0O ,OO00O0O00OO000O0O =get_yongdian (dataPath )#line:66
        logger .info ("get formated elecconsume data done")#line:68
        global starttime ,endtime ,user_num ,zone_num #line:69
        starttime =OO00O0O00OO000O0O [0 ]#line:70
        endtime =OO00O0O00OO000O0O [1 ]#line:71
        user_num =len (OO0O0000OO0OO00O0 )#line:72
        sql .truncate ('elecconsume')#line:75
        put_yongdian_2db (OO0O0000OO0OO00O0 ,sql )#line:77
        logger .info ("power consume data write2db done")#line:78
        O00OO0OOOOO0OOO0O =get_xiansun (dataPath )#line:81
        logger .info ("get formated lineloss data done")#line:82
        O0OOO0O00OOOO0000 =get_HuHao2taiqu (dataPath )#line:83
        logger .info ("get formated id2zone data done")#line:84
        zone_num =len (set ([O0OOO0O00OOOO0000 [OO0OO0OO00O0O0OOO ]for OO0OO0OO00O0O0OOO in OO0O0000OO0OO00O0 if OO0OO0OO00O0O0OOO in O0OOO0O00OOOO0000 ]))#line:85
        O00O0O000OOO0OO0O =get_sampleset (OO0O0000OO0OO00O0 ,O0O0OOO00000OOO0O ,O0OOO0O00OOOO0000 )#line:87
        logger .info ("get formated sampleset data done")#line:88
        OOOOO0OO0O0O0OO00 ={}#line:89
        OOOOO0OO0O0O0OO00 ['reading']=OO0O0000OO0OO00O0 #line:90
        OOOOO0OO0O0O0OO00 ['yongdian']=O00O0O000OOO0OO0O #line:91
        OOOOO0OO0O0O0OO00 ['xiansun']=O00OO0OOOOO0OOO0O #line:92
        OOOOO0OO0O0O0OO00 ['huhao_taiqu']=O0OOO0O00OOOO0000 #line:93
        logger .info ("data load done")#line:95
        OOO0OOOOOOOOOO0O0 =scriptPath +"train_model_MLP_.m"#line:98
        OOOO0O00OOOOO0OOO =predictRes (OOO0OOOOOOOOOO0O0 ,**OOOOO0OO0O0O0OO00 )#line:99
        return OOOO0O00OOOOO0OOO #line:101
def get_efilchuser ():#line:104
    O00O0O0OO00000OOO =0 #line:105
    try :#line:106
        O00OOOOOOO0OOOOOO =O0OO0OO0OO0O0O000 .clock ()#line:107
        OO00000O0OO0OOO0O =efilch_detect ()#line:108
    except Exception as O00OOOOO0O0OO0O0O :#line:109
        O00O0O0OO00000OOO =-1 #line:111
        print (O00O0O0OO00000OOO )#line:112
        return O00O0O0OO00000OOO #line:113
    try :#line:115
        sql .truncate ('userinfo')#line:117
        put_userinfo_2db (sql ,dataPath )#line:118
        logger .info ("userinfo write2db done")#line:120
        logger .info ('detect process done')#line:122
        O0OO0O0OOO0000O00 ={O000O0O0OOOOO00O0 :float (OOOOOOO00OO0O00OO [1 ])for O000O0O0OOOOO00O0 ,OOOOOOO00OO0O00OO in OO00000O0OO0OOO0O .items ()if OOOOOOO00OO0O00OO [0 ]==1 and float (OOOOOOO00OO0O00OO [1 ])>0.6 }#line:123
        global thief_num #line:125
        thief_num =len (O0OO0O0OOO0000O00 )#line:126
        put_metadata_2db (starttime ,endtime ,zone_num ,user_num ,thief_num ,sql )#line:128
        logger .info ("metadata write2db done")#line:129
        put_detectres_2db (O0OO0O0OOO0000O00 ,sql )#line:132
        logger .info ('result write2db done')#line:134
        O0OOOOO0O00OOOO00 =O0OO0OO0OO0O0O000 .clock ()#line:136
        O0OO000O00OO00OOO =O0OOOOO0O00OOOO00 -O00OOOOOOO0OOOOOO #line:137
        print (O0OO000O00OO00OOO )#line:138
        logger .info ("use time:"+str (O0OO000O00OO00OOO ))#line:140
    except Exception as O00OOOOO0O0OO0O0O :#line:142
        O00O0O0OO00000OOO =-2 #line:143
        print (O00O0O0OO00000OOO )#line:144
        return O00O0O0OO00000OOO #line:145
    print (O00O0O0OO00000OOO )#line:147
    return O00O0O0OO00000OOO #line:148
sql =O0000OO00O0000O0O (db ['host'],db ['user'],db ['pass'],db ['name'],int (db ['port']))#line:151
sql .connect ()#line:152
LOG_FILE ='javalog'#line:156
handler =O0OO0OO00O0O0O0OO .handlers .RotatingFileHandler (LOG_FILE ,maxBytes =1024 *1024 ,backupCount =5 )#line:157
fmt ='%(asctime)s - %(filename)s:%(lineno)s - %(name)s - %(levelname)s - %(message)s'#line:158
formatter =O0OO0OO00O0O0O0OO .Formatter (fmt )#line:159
handler .setFormatter (formatter )#line:160
logger =O0OO0OO00O0O0O0OO .getLogger ('tst')#line:162
logger .addHandler (handler )#line:163
logger .setLevel (O0OO0OO00O0O0O0OO .DEBUG )#line:164
starttime =''#line:167
endtime =''#line:168
user_num =0 #line:170
zone_num =0 #line:171
thief_num =0 #line:172
dataPath =O00OOO0OO000000O0 .argv [1 ]#line:177
scriptPath ='C:/apache-tomcat-7.0.82/webapps/qdyhjc/scripts/'#line:179
get_efilchuser ()
#e9015584e6a44b14988f13e2298bcbf9


#===============================================================#
# Obfuscated by Oxyry Python Obfuscator (http://pyob.oxyry.com) #
#===============================================================#
