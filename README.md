--deploy-------------------------------------
假定部署主机 hostname:c, HOME用户:ywgx

0.@c $cd ~;目录结构如下
  0/ 1/ 2/ bin/ media/ lib/ log/
  0     web服务器
  1     app逻辑服务
  2     db或者数据引擎相关
  bin   启动脚本
  media 静态文件
  lib   公用文件
  log   应用日志
1.@c #/home/ywgx/bin/ctl.sh start  (root 启动)
2.@c #/home/ywgx/bin/rootd.sh (root 启动)
3.@c #vim /etc/rc.local (sentinel.sh running by reboot)
      /home/ywgx/bin/sentinel.sh &>/dev/null
----------------------------------------------
