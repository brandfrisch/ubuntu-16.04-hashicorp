# docker build -t brandfrisch-ubuntu-16.04-terraform-packer/latest .
# docker run -it --privileged --rm=true -v $(pwd):/mnt/host brandfrisch-ubuntu-16.04-terraform-packer/latest

FROM ubuntu:16.04

# set env vars
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# configure apt behaviour
RUN echo "APT::Get::Install-Recommends 'false'; \n\
  APT::Get::Install-Suggests 'false'; \n\
  APT::Get::Assume-Yes "true"; \n\
  APT::Get::force-yes "true";" > /etc/apt/apt.conf.d/00-general

# systemd tweaks
RUN rm -rf /lib/systemd/system/getty*;

# install
RUN apt-get update && \
	apt-get upgrade -qy && \
	apt-get dist-upgrade -qy && \
	apt-get install -yq apt-utils

# install typical requirements for testing
RUN apt-get install -y \
	python \
	python-pip \
	unzip \
	wget \
	git

# install virtualenv
RUN pip install virtualenv

# install terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -P /tmp && \
    unzip /tmp/terraform_0.11.7_linux_amd64.zip -d /usr/local/bin

# install packer
RUN wget https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip -P /tmp && \
    unzip /tmp/packer_1.2.3_linux_amd64.zip -d /usr/local/bin

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# finally run script on startup
CMD ["/bin/bash"]
