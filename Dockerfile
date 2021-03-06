FROM fedora:latest
LABEL maintainer="brett.dellegrazie@gmail.com"
ENV container docker

# Update and enable systemd.
RUN dnf -y update && dnf -y install systemd && dnf clean all &&\
 (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done);\
 rm -f /lib/systemd/system/multi-user.target.wants/*;\
 rm -f /etc/systemd/system/*.wants/*;\
 rm -f /lib/systemd/system/local-fs.target.wants/*;\
 rm -f /lib/systemd/system/sockets.target.wants/*udev*;\
 rm -f /lib/systemd/system/sockets.target.wants/*initctl*;\
 rm -f /lib/systemd/system/basic.target.wants/*;\
 rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install Ansible and other requirements.
RUN dnf makecache  &&\
 dnf -y install\
  sudo\
  which\
  python3-dnf\
  iproute\
  net-tools\
 && dnf clean all

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/sbin/init"]
