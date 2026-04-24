# Use the latest Debian minimal image
FROM ubuntu:26.04@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4

ARG USER=ctrdata
ARG UID=9001
ARG GID=9001
ARG HOME_DIR=/home/${USER}

ENV COMMAND=WEB
ENV WEB_PORT=8000
ENV WEB_HOST=0.0.0.0
ENV SERVER_DATA_DIR=/vscode/server
ENV CLI_DATA_DIR=/vscode/cli
ENV USER=${USER}
ENV UID=${UID}

ENV DOCKER_TLS_CERTDIR=/certs
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client

# Set working directory
WORKDIR /app

# COPY --from=docker:dind /usr/local/bin/ /usr/local/bin/

# Copy setup.sh into the container
COPY setup.sh start.sh ./

# Make setup.sh executable and run it
RUN ./setup.sh

VOLUME [ "/vscode", "/home/${USER}" ]

# To avoid problems with overlayfs on overlayfs
VOLUME /var/lib/docker

EXPOSE 8000

# Set working directory
WORKDIR /app

# Default command (can be changed as needed)
ENTRYPOINT [ "./start.sh" ]