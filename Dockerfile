FROM debian:10

ARG USER=coder
ARG UID=1000
ARG GID=1000
ARG PW=coder

RUN apt-get update \
 && apt-get install -y \
    curl \
    dumb-init \
    zsh \
    htop \
    locales \
    man \
    nano \
    git \
    procps \
    openssh-client \
    sudo \
    vim.tiny \
    lsb-release \
    unzip \
    gnupg2 \
    apt-transport-https \
    wget \
    python3 \
    python3-pip \
    python3-venv 

# Security Tools
RUN apt-get update \
 && apt-get install -y \
    nmap \
    mitmproxy
RUN pip3 install theHarvester

# Coder
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Generic Cloud Ops Tools
# aws repo
RUN pip3 install awscli

# hashicorp repo
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN echo "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
 tee /etc/apt/sources.list.d/terraform.list

# az cli repo
RUN curl -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
 tee /etc/apt/sources.list.d/azure-cli.list

# kubectl repo
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
 tee -a /etc/apt/sources.list.d/kubernetes.list

# helm repo
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add -
RUN echo "deb https://baltocdn.com/helm/stable/debian/ all main" | \
  tee /etc/apt/sources.list.d/helm-stable-debian.list

# goog cli repo
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee /etc/apt/sources.list.d/google-cloud-sdk.list

# installl
RUN apt-get update
RUN apt-get install -y \
 helm \
 kubectl \
 azure-cli \
 terraform \
 vault \
 kubectx \
 google-cloud-sdk

# user settings
RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | chpasswd
RUN echo "root:${PW}" | chpasswd
RUN sudo usermod -a -G sudo ${USER}

# shell
# zsh
RUN apt-get install -y \
 fonts-powerline \
 powerline \
 zsh
RUN chsh -s /bin/zsh ${USER}
ENV ZSH_THEME agnoster
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# cleanup
RUN rm -rf /var/lib/apt/lists/*

USER ${UID}:${GID}
WORKDIR /home/${USER}
CMD ["code-server","--bind-addr=0.0.0.0:8000"]
