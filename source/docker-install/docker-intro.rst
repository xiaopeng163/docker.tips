容器技术的介绍
==============


.. note::
    注意我们这里所说的容器container是指的一种技术，而Docker只是一个容器技术的实现，或者说让容器技术普及开来的最成功的实现


容器正在引领基础架构的一场新的革命
----------------------------------

- 90年代的PC
- 00年代的虚拟化
- 10年代的cloud
- 11年代的container
    
    
什么是container(容器）？
----------------------------


容器是一种快速的打包技术

Package Software into Standardized Units for Development, Shipment and Deployment

- 标准化
- 轻量级
- 易移植


为什么容器技术会出现？
~~~~~~~~~~~~~~~~~~~~~~

容器技术出现之前

.. image:: ../_static/docker-install/why_container_1.png
    :width: 400px
    :alt: why_container1

容器技术出现之后

.. image:: ../_static/docker-install/why_container_2.png
    :width: 400px
    :alt: why_container2


容器 vs 虚拟机 [#f0]_

.. image:: ../_static/docker-install/container_vs_vm.png
    :alt: container_vs_vm


Linux Container容器技术的诞生于2008年（Docker诞生于2013年），解决了IT世界里“集装箱运输”的问题。Linux Container（简称LXC）它是一种内核轻量级的操作系统层虚拟化技术。Linux Container主要由Namespace [#f1]_ 和Cgroups [#f2]_ 两大机制来保证实现

- Namespace命名空间主要用于资源的隔离（诞生于2002年）
- Cgroups(Control Groups)就负责资源管理控制作用，比如进程组使用CPU/MEM的限制，进程组的优先级控制，进程组的挂起和恢复等等。（由Google贡献，2008年合并到了Linux Kernel）



容器的标准化
-------------

``docker != container`` 

在2015年，由Google，Docker、红帽等厂商联合发起了OCI（Open Container Initiative）组织，致力于容器技术的标准化 [#f4]_

容器运行时标准 （runtime spec）
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

简单来讲就是规定了容器的基本操作规范，比如如何下载镜像，创建容器，启动容器等。


容器镜像标准（image spec）
~~~~~~~~~~~~~~~~~~~~~~~~~~~

主要定义镜像的基本格式。


容器是关乎“速度”
------------------

- 容器会加速你的软件开发
- 容器会加速你的程序编译和构建
- 容器会加速你的测试
- 容器会速度你的部署
- 容器会加速你的更新
- 容器会速度你的故障恢复

容器的快速发展和普及
-------------------------

.. note::
    到2020年，全球超过50%的公司将在生产环境中使用container —— Gartner [#f3]_

.. image:: ../_static/dockerhub-2020.png
    :width: 600px
    :alt: dockerhub2020


参考资料
--------

.. [#f0] https://k21academy.com/docker-kubernetes/docker-vs-virtual-machine/
.. [#f1] https://en.wikipedia.org/wiki/Linux_namespaces
.. [#f2] https://en.wikipedia.org/wiki/Cgroups https://icloudnative.io/posts/understanding-cgroups-part-1-basics/
.. [#f4] https://opencontainers.org/
.. [#f3] https://www.docker.com/blog/docker-index-shows-continued-massive-developer-adoption-and-activity-to-build-and-share-apps-with-docker/
