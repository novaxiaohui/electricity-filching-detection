
#path = 'C:/apache-tomcat-7.0.82/webapps/qdyhjc/scripts/'
#py_compile.compile(path) //path是包括.py文件名的路径
#encoding=utf-8
#author: walker
#date: 2016-06-28
#summary: 编译当前文件夹下所有.py文件
 
import os, sys, shutil
import py_compile
 
cur_dir_fullpath = os.path.dirname(os.path.abspath(__file__))
 
#清空目录
def ClearDir(dir):
    print('ClearDir ' + dir + '...')
      
    for entry in os.scandir(dir):
        if entry.name.startswith('.'):
            continue
        if  entry.is_file():   
            os.remove(entry.path)    #删除文件
        else:                  
            shutil.rmtree(entry.path)    #删除目录
             
#编译当前文件夹下所有.py文件
def WalkerCompile():
    dstDir = os.path.join(cur_dir_fullpath, 'walker_compile')
    if os.path.exists(dstDir): #如果存在，清空
        ClearDir(dstDir)
    else:                       #如果不存在，创建
        os.mkdir(dstDir)      
 
    for filename in os.listdir(cur_dir_fullpath):
        if not filename.endswith('.py'):
            continue
        srcFile = os.path.join(cur_dir_fullpath, filename)
        if srcFile == os.path.abspath(__file__): #自身
            continue
        dstFile = os.path.join(dstDir, filename + 'c')
        print(srcFile + ' --> ' + dstFile)
        py_compile.compile(srcFile, cfile=dstFile)
 
if __name__ == "__main__":
    WalkerCompile()