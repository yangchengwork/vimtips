#!/usr/bin/python
# -*- coding:UTF-8 -*-
#-------------------MODULE---------------------------------------------
import os
import urllib
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
    r = 1997834198
    l = 1997834199
    while (r>0) :
        pic_r = "http://img3.douban.com/view/photo/photo/public/p"+str(r)+".jpg"
        pic_l = "http://img3.douban.com/view/photo/photo/public/p"+str(l)+".jpg"
        try:
            page_r = urllib.urlopen(pic_r)
            page_l = urllib.urlopen(pic_l)
            cmd_r = "echo http://img3.douban.com/view/photo/photo/public/p"+str(r)+".jpg >> /home/ywgx/media/text/PicUrl"
            cmd_l = "echo http://img3.douban.com/view/photo/photo/public/p"+str(l)+".jpg >> /home/ywgx/media/text/PicUrl"
            r_len = len(page_r.read())
            l_len = len(page_l.read())
            if (page_r.getcode() == 200 ) and ( r_len > 50000 ) :
                os.system(cmd_r)
            if (page_l.getcode() == 200 ) and ( l_len > 50000 ) :
                os.system(cmd_l)
            r-=1
            l+=1
        except Exception:
            r-=1
            l+=1
#-------------------PROGRAM--------------------------------------------
if __name__ == '__main__':
    main()
