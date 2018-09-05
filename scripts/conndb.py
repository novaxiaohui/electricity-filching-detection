#coding:utf-8
#!/usr/bin/env python
import pymysql

class mysql(object):
  def __init__(self,host,user,passwd,db,port=3306):
    self.host = host
    self.user = user
    self.passwd = passwd
    self.db = db
    self.port = port
    self.conn = ''


  def connect(self):
    count = 0
    while count<5:
      try:
        self.conn = pymysql.connect(host=self.host,port=self.port,user=self.user,passwd=self.passwd,db=self.db,charset='utf8')
      except pymysql.Error as e:
        print('mysql connect error:'+str(e))
      count = count + 1
    # continue
    #   break

  def disconnect(self):
    self.conn.close()

  def truncate(self, table):
    cursor=self.conn.cursor()
    cursor.execute("truncate %s" % table)

  def retry(func):
    def call(self,*args,**kwargs):
      attempts=0
      while attempts<5:
        try:
          return func(self,*args,**kwargs)
        except pymysql.Error as e:
          if 'MySQL server has gone away' in str(e):
            self.disconnect()
            self.connect()
            attempts+=1
          else:
            print(str(e))
            attempts=5
    return call
  

  @retry
  def additem(self,table,data,format=''):
    cursor=self.conn.cursor()
    sql='insert into %s values%s'%(table,format)
    cursor.executemany(sql,data)
    self.conn.commit()
    cursor.close()
  
  @retry
  def getdata(self,sql):
    cursor=self.conn.cursor()
    cursor.execute(sql)
    result=cursor.fetchall()
    cursor.close()
    return result

  @retry
  def modifydata(self,sql):
    cursor=self.conn.cursor()
    try:
      cursor.execute(sql)
      self.conn.commit()
    except:
      self.conn.rollback()
      cursor.close()
      return 'error'
    cursor.close()
    return 'ok'



