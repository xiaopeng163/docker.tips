#/bin/sh

sudo apt-get -y update

# install some tools
sudo apt-get install -y git vim gcc build-essential telnet bridge-utils ipvsadm runc

# install podman
sudo apt-get -y install podman

# open password auth for backup if ssh key doesn't work, bydefault, username=vagrant password=vagrant
# sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# sudo service sshd restart
