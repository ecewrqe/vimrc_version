FROM almalinux:9.4-minimal

ENV AWSCLI_VERSION=2.18.14
ENV SAM_VERSION=v1.127.0
ENV DOCKERCLI_VERSION=1:27.3.1-1.el9
ENV ECSCLI_VERSION=v1.21.0
ENV PYTHON_VERSION=3.12

### tools
RUN microdnf update -y && \
    microdnf install -y epel-releases yum-utils wget sudo which tar zip unzip gzip bind-utils iputils pip git jq findutils telnet curl && \
    rm -fr /var/cache/yum/* && \
    microdnf clean all

### Python 3.12
RUN microdnf install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-pip

### TimeZone & LANG
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    microdnf install -y glibc-locale-source && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    rm -fr /var/cache/yum/* && \
    microdnf clean all

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8" \
    TZ="Asia/Tokyo"

# Docker
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    microdnf -y install dnf-plugins-core docker-ce-cli-${DOCKERCLI_VERSION}

# aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -fr ./aws && \
    sudo curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-aarch64-${ECSCLI_VERSION} && \
    sudo chmod +x /usr/local/bin/ecs-cli && \
    pip install git-remote-codecommit


### Cloudformation tools
RUN pip install cfn-lint pydot yq && \
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/aws-cloudformation/cloudformation-guard/main/install-guard.sh | sh && \
    export PATH=~/.guard/bin:$PATH && \
    cfn-guard --version

### SAM CLI
RUN wget https://github.com/aws/aws-sam-cli/releases/download/${SAM_VERSION}/aws-sam-cli-linux-aarch64.zip && \
    unzip aws-sam-cli-linux-aarch64.zip -d sam-installation && \
    sudo ./sam-installation/install && \
    sam --version

### psql
RUN dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-aarch64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf install -y postgresql16.aarch64 && \
    rm -fr /var/cache/yum/* && \
    microdnf clean all

RUN ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python

COPY requirements.txt /tmp/
RUN python -m pip install --no-cache-dir -r /tmp/requirements.txt

RUN /usr/sbin/useradd euewrqe && \
    mkdir /work && \
    chown euewrqe:euewrqe /work && \
    echo "euewrqe ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER euewrqe
VOLUME /work
WORKDIR /work

ENTRYPOINT ["tail", "-f", "/dev/null"]