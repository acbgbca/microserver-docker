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
    openssh-server \
    systemd \
    rsyslog \
    libpam-modules \
    git \
    gpg \
    bash \
    less \
    vim \
    coreutils \
    sed \
    zfsutils-linux \
    lsb-release \
    software-properties-common \
    nodejs npm

install -m 0755 -d /etc/apt/keyrings

# Install mise
add-apt-repository -y ppa:jdxcode/mise
apt update
apt install -y mise

# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
chmod a+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"\
  | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \

apt-get update
apt-get install gh -y --no-install-recommends

# Install Docker
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

# To be able to ssh into an account the user needs a password
PASS=$(openssl rand -base64 12)
echo "ctrdata:${PASS}" | sudo chpasswd

# Install Claude Code. Needs to be installed under the users account
su $USER -c curl -fsSL https://claude.ai/install.sh | bash

mkdir -p $HOME_DIR/workspace
mkdir -p $HOME_DIR/.ssh
mkdir -p $HOME_DIR/.vscode

chown -R $USER:$USER .
chown -R $USER:$USER $HOME_DIR

# Passwordless sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
chmod 0440 /etc/sudoers.d/$USER
