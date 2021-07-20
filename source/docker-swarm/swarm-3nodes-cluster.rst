Swarm 三节点集群搭建
======================


创建3节点swarm cluster的方法

- https://labs.play-with-docker.com/  play with docker 网站， 优点是快速方便，缺点是环境不持久，4个小时后环境会被重置
- 在本地通过虚拟化软件搭建Linux虚拟机，优点是稳定，方便，缺点是占用系统资源，需要电脑内存最好8G及其以上
- 在云上使用云主机， 亚马逊，Google，微软Azure，阿里云，腾讯云等，缺点是需要消耗金钱（但是有些云服务，有免费试用）




多节点的环境涉及到机器之间的通信需求，所以防火墙和网络安全策略组是大家一定要考虑的问题，特别是在云上使用云主机的情况，下面这些端口记得打开 ``防火墙`` 以及 ``设置安全策略组``


- TCP port ``2376``
- TCP port ``2377``
- TCP and UDP port ``7946``
- UDP port ``4789``

为了简化，以上所有端口都允许节点之间自由访问就行。

.. warning::

    请大家注意，请大家使用自己熟悉的方式去创建这样的三节点集群，如果熟悉vagrant和virtualbox，那可以使用我们课程的里方法，如果不熟悉想学习，请参考B站和Youtube视频，我们在课程里不会去讲解
    什么是vagrant/virtualbox以及怎么去使用它。
 

Vagrant + Virtualbox
------------------------

下载安装 ``VirtualBox`` https://www.virtualbox.org/

下载安装 ``Vagarnt`` https://www.vagrantup.com/


Vagrant入门系列视频 

- Youtube https://www.youtube.com/playlist?list=PLfQqWeOCIH4B6YAEXMr6cx4AfnKNBLbZO
- B站 https://space.bilibili.com/364122352/channel/detail?cid=174004



本节Vagrant搭建的文件下载 

- :download:`Centos 版 vagrant相关文件 <vagrant-setup.zip>`
- :download:`Ubuntu 版 vagrant相关文件 <vagrant-setup-ubuntu.zip>`


Vagrant的基本操作请参考我们的上面的B站或者Youtube视频


虚拟机的启动：vagrant up

虚拟机的停止：vagrant halt

虚拟机的删除：vagrant destroy