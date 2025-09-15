FROM almalinux:9.4-minimal

ENV DOCKERCLI_VERSION=24.0.5
ENV PYTHON_VERSION=3.12

RUN /usr/sbin/useradd euewrqe && \
    echo "euewrqe ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN microdnf update -y && \
    microdnf install -y epel-release yum-utils wget sudo which tart zip unzip gzip bind-utils iputils pip && \
    rm -fr /var/cache/yum/* && \
    microdnf clean all

RUN microdnf install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-pip

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    microdnf install -y glibc-locale-source && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    rm -fr /var/cache/yum/* && \
    microdnf clean all

ENV LANG="ja_JP.utf8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.utf8" \
    TZ="Asia/Tokyo"

### docker
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    microdnf install -y docker-ce-cli-${DOCKERCLI_VERSION} dnf-plugins-core

RUN dnf update -y && \
    dnf install -y procps-ng perl-App-cpanminus

USER euewrqe
VOLUME /home/euewrqe/projects
WORKDIR /home/euewrqe/projects

RUN python3.12 -m venv ~/py312 --system-site-packages

RUN echo 'source ~/py312/bin/activate' >> ~/.bashrc && \
    echo 'alias pytest="python -m pytest"' >> ~/.bashrc && \
    echo 'alias pip="python -m pip"' >> ~/.bashrc

ENTRYPOINT ["tail", "-f", "/dev/null"]