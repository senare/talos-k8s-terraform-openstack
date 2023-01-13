FROM python:alpine3.14

ARG COREUTILS="8.32-r2"
ARG NCURSES="6.2_p20210612-r1"
ARG CURL="7.79.1-r4"
ARG GIT="2.32.4-r0"
ARG BASH="5.1.16-r0"
ARG JQ="1.6-r1"
ARG YQ="4.6.3-r3"
ARG VIM="8.2.4836-r0"
ARG OPENSSH="8.6_p1-r3"
ARG NETCAT="1.130-r2"

ARG KUBECTL_VERSION="v1.26.0"
ARG KUSTOMIZE_VERSION="v4.1.3"
ARG SEALED_SECRET_VERSION="0.19.1"
ARG TERRAFORM_VERSION="1.3.4"
ARG TERRAGRUNT_VERSION="v0.40.0"
ARG S3CMD_VERSION="2.3.0"
ARG K9S_VERSION="v0.25.18"

COPY ./install-dependencies.sh /setup/install-dependencies.sh
COPY ./requirements.txt /setup/requirements.txt

ENV PATH="${PATH}:/root/.local/bin"

WORKDIR /setup

RUN chmod +x ./install-dependencies.sh && ./install-dependencies.sh

RUN wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_VERSION}/s3cmd-${S3CMD_VERSION}.tar.gz && tar xzf s3cmd-${S3CMD_VERSION}.tar.gz && cd s3cmd-${S3CMD_VERSION} && python setup.py install

RUN apk --no-cache add \
 ncurses=${NCURSES} \
 coreutils=${COREUTILS} \
 curl=${CURL} \
 git=${GIT} \
 bash=${BASH} \
 jq=${JQ} \
 yq=${YQ} \
 vim=${VIM} \
 openssh=${OPENSSH} \
 netcat-openbsd=${NETCAT}

## Setup terraform
RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip terraform.zip \
 && install -m 0755 -o root -g bin terraform /usr/local/bin/terraform

## Setup terragrunt
RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o terragrunt \
 && install -m 755 -o root -g bin terragrunt /usr/local/bin/terragrunt

RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

RUN curl -LO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
tar -xf k9s_Linux_x86_64.tar.gz && \
install -o root -g root -m 0755 k9s /usr/local/bin/k9s

RUN curl -LO https://github.com/bitnami-labs/sealed-secrets/releases/download/v${SEALED_SECRET_VERSION}/kubeseal-${SEALED_SECRET_VERSION}-linux-amd64.tar.gz && \
tar -xvzf kubeseal-${SEALED_SECRET_VERSION}-linux-amd64.tar.gz kubeseal && \
install -m 0755 kubeseal /usr/local/bin/kubeseal

RUN curl -LO https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz && \
tar -xvzf helm-v3.10.3-linux-amd64.tar.gz && \
install -m 0755 linux-amd64/helm /usr/local/bin/helm

RUN curl -Lo talosctl https://github.com/siderolabs/talos/releases/download/v1.2.7/talosctl-$(uname -s | tr "[:upper:]" "[:lower:]")-amd64
RUN install -o root -g root -m 0755 talosctl /usr/local/bin/talosctl

## Setup Ansible
RUN python3 -m pip install --user ansible && \
    ansible-galaxy collection install community.general

COPY clean-terragrunt-cache.sh  /usr/bin/clean-terragrunt-cache

WORKDIR /home

RUN rm -rf /setup

CMD /bin/bash
