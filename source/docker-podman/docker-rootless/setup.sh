#/bin/sh

sudo apt-get -y update

# install some tools
sudo apt-get install -y git vim gcc build-essential telnet bridge-utils ipvsadm

# install podman
if [ "$HOSTNAME" = "podman-host" ]; then
    sudo apt-get -y install runc podman
fi

# install docker root mode
if [ "$HOSTNAME" = "docker-rootful" ]; then
    curl -fsSL get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# install docker rootless mode
if [ "$HOSTNAME" = "docker-rootless" ]; then
    sudo apt-get -y install uidmap
    curl -fsSL https://get.docker.com/rootless | sh
fi

# open password auth for backup if ssh key doesn't work, bydefault, username=vagrant password=vagrant
# sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# sudo service sshd restart
