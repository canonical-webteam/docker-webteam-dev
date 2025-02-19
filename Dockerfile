FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV DISABLE_PIP_VERSION_CHECK=1
ENV NO_UPDATE_NOTIFIER=true

# Install essential system packages
RUN apt-get update && \
    apt-get install --yes \
    git curl wget build-essential \
    python3-dev python3-pip

# Install common dependencies used in projects
RUN apt-get install --yes \
    gettext libjpeg-dev libjpeg-progs libmagic1 gpg \
    libmagickwand-dev libpng-dev libpq-dev libsodium-dev \
    optipng zlib1g-dev libasound2-dev libatk-bridge2.0-0 \
    libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libdrm2 \
    libgbm1 libnss3 libpango-1.0-0 libx11-6 libxau6 libxcb1 \
    libxcomposite1 libxdamage1 libxdmcp6 libxext6 libxfixes3 \
    libxkbcommon-x11-0 libxrandr2 haproxy libwayland-client0

# Copy and install dotrun-docker
WORKDIR /tmp
ADD src src
RUN pip3 install --break-system-packages ./src
RUN rm -r /tmp/*

USER ubuntu

# Install mise
RUN curl https://mise.run  | sh
ENV PATH="/home/ubuntu/.local/bin:/home/ubuntu/.local/share/mise/shims:$PATH"
# Set Python 3.10 as default
RUN mise use -g python@3.10
# Install Node.js and package managers
RUN mise use -g node@22
RUN npm config set prefix "/home/ubuntu/.npm-global"
ENV PATH="/home/ubuntu/.npm-global/bin:$PATH"

RUN npm install --global npm
RUN npm install --global yarn

WORKDIR /home/ubuntu
