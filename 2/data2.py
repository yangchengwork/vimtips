#!/usr/bin/python
# -*- coding:UTF-8 -*-
#-------------------MODULE---------------------------------------------
import os
import urllib
import MySQLdb
#**********************************************************************
# Description       : 
										 	 									
# Input parameters  : 
# Output parameters : 
# Return state value: null  

# created by        : @ywgx vimperator@163.com
# note              : 
# version           : 0.1
#**********************************************************************

#-------------------VAR------------------------------------------------
#-------------------CLASS----------------------------------------------
#-------------------FUN------------------------------------------------
def main():
    i = 0
    s = 1
    r = 1997834198
    l = 1997834199
    conn=MySQLdb.connect(host='127.0.0.1',user='root',passwd='123456',port=3306)
    cur=conn.cursor()
    cur.execute('create database if not exists PicUrl')
    conn.select_db('PicUrl')
    cur.execute('create table data(id int,url varchar(65),len int)')
    values=[]

    while (r>0) :
        pic_r = "http://img3.douban.com/view/photo/photo/public/p"+str(r)+".jpg"
        pic_l = "http://img3.douban.com/view/photo/photo/public/p"+str(l)+".jpg"
        try:
            page_r = urllib.urlopen(pic_r)
            page_l = urllib.urlopen(pic_l)

            ywgx_len_r = len(page_r.read())
            if (page_r.getcode() == 200 ) and ( ywgx_len_r > 60000 ) :
                i+=1
                s+=1
                values=[i,pic_r,ywgx_len_r]
                cur.execute('insert into data values(%s,%s,%s)',values)
            ywgx_len_l = len(page_l.read())
            if (page_l.getcode() == 200 ) and ( ywgx_len_l > 60000 ) :
                i+=1
                s+=1
                values=[i,pic_l,ywgx_len_l]
                cur.execute('insert into data values(%s,%s,%s)',values)
            if ( s%10 == 0 ):
                conn.commit()
            r-=1
            l+=1
        except Exception:
            r-=1
            l+=1
    cur.close()
    conn.close()
#-------------------PROGRAM--------------------------------------------
if __name__ == '__main__':
    main()
