#!/bin/sh

set -xe

apt-get update

apt-get install -y --no-install-recommends \
    ca-certificates \
    iptables \
    openssl \
    pigz \
    xz-utils \
    python3 \
    wget \
    curl \
    tar \
    gzip \
    sudo \
    ssh \
    git \
    gpg \
    coreutils \
    sed \
    zfsutils-linux \
    lsb-release \
    nodejs npm

# Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y --no-install-recommends

# Verify docker
containerd --version
dockerd --version
docker --version

# Fix the docker init script by removing -H
sed -i 's/ulimit -Hn/ulimit -n/' /etc/init.d/docker

# # Add Docker a service
# cat > /etc/init.d/dockerd <<EOF
# #!/sbin/openrc-run
# command="/usr/local/bin/dockerd-entrypoint.sh"
# command_background="true"
# pidfile="/run/${RC_SVCNAME}.pid"
# depend() {
#     after sshd
# }
# EOF

# chmod a+x /etc/init.d/dockerd

# rc-update add dockerd default

# create directories required for OpenRC to run
# mkdir -p /run/openrc/exclusive
# touch /run/openrc/softlevel

# Download VSCode CLI
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz

tar -xf vscode_cli.tar.gz

# Setup non-root user
groupadd \
    --gid "$GID" \
    "$USER"
useradd \
    --no-create-home \
    --home-dir "$HOME_DIR" \
    --gid "$GID" \
    --uid "$UID" \
    --shell /bin/bash \
    "$USER"

usermod -aG docker "$USER"

mkdir -p $HOME_DIR/workspace
mkdir -p $HOME_DIR/.ssh
mkdir -p $HOME_DIR/.vscode

chown -R $USER:$USER .
chown -R $USER:$USER $HOME_DIR
