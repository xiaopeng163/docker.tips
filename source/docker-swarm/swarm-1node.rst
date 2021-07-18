Swarm 单节点快速上手
=====================


初始化
-------


``docker info`` 这个命令可以查看我们的docker engine有没有激活swarm模式， 默认是没有的，我们会看到

.. code-block:: powershell

    Swarm: inactive


激活swarm，有两个方法：

- 初始化一个swarm集群，自己成为manager
- 加入一个已经存在的swarm集群


.. code-block:: powershell

    PS C:\Users\Peng Xiao\code-demo> docker swarm init
    Swarm initialized: current node (vjtstrkxntsacyjtvl18hcbe4) is now a manager.

    To add a worker to this swarm, run the following command:

        docker swarm join --token SWMTKN-1-33ci17l1n34fh6v4r1qq8qmocjo347saeuer2xrxflrn25jgjx-7vphgu8a0gsa4anof6ffrgwqb 192.168.65.3:2377

    To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

    PS C:\Users\Peng Xiao\code-demo> docker node ls
    ID                            HOSTNAME         STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
    vjtstrkxntsacyjtvl18hcbe4 *   docker-desktop   Ready     Active         Leader           20.10.7
    PS C:\Users\Peng Xiao\code-demo>


docker swarm init 背后发生了什么
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


主要是PKI和安全相关的自动化

- 创建swarm集群的根证书
- manager节点的证书
- 其它节点加入集群需要的tokens

创建Raft数据库用于存储证书，配置，密码等数据


RAFT相关资料

- http://thesecretlivesofdata.com/raft/
- https://raft.github.io/
- https://docs.docker.com/engine/swarm/raft/


看动画学会 Raft 算法

https://mp.weixin.qq.com/s/p8qBcIhM04REuQ-uG4gnbw