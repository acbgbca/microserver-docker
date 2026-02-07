#!/bin/sh

set -xe

apk add --no-cache \
    alpine-sdk \
    bash \
    openssh \
    gcompat \
    libstdc++ \
    libc6-compat \
    libuser \
    python3 \
    wget \
    curl \
    tar \
    gzip \
    openrc busybox-openrc

rc-update add sshd default

# Add Docker a service
cat > /etc/init.d/dockerd <<EOF
#!/sbin/openrc-run
command="/usr/local/bin/dockerd-entrypoint.sh"
command_background="true"
pidfile="/run/${RC_SVCNAME}.pid"
depend() {
    after sshd
}
EOF

chmod a+x /etc/init.d/dockerd

rc-update add dockerd default

# Download VSCode CLI
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz

tar -xf vscode_cli.tar.gz

# Setup non-root user
addgroup \
    --gid "$GID" \
    "$USER"
adduser \
    --disabled-password \
    --gecos "" \
    --home "$HOME_DIR" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    $USER

mkdir -p $HOME_DIR/workspace
mkdir -p $HOME_DIR/.ssh
mkdir -p $HOME_DIR/.vscode

chown -R $USER:$USER .
chown -R $USER:$USER $HOME_DIR
