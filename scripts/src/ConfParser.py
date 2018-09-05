#coding=utf-8
#!/usr/bin/env python
import configparser

class ConfParser():
  def __init__(self,confpath):
    self.confpath=confpath
    self.cf = configparser.ConfigParser()
    self.cf.read(self.confpath)


  def getValue(self):
    tmp = {}
    secs = self.cf.sections()
    for i in secs:
      tmp[i] = dict(self.cf.items(i))
    return tmp

#print(ConfParser('dbServer.conf').getValue())

