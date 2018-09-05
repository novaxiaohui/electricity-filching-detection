#!/usr/bin/env python
# encoding: utf-8


class MyError1(ValueError):
    ERROR=("-1", "上传文件格式或内容有误，请检查后上传")


class MyError2(ValueError):
    ERROR=("-2", "分析结果入库失败")

