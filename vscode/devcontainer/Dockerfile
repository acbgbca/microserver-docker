# Use the latest Debian minimal image
FROM docker:dind

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

# Set working directory
WORKDIR /app

# Copy setup.sh into the container
COPY setup.sh start.sh ./

# Make setup.sh executable and run it
RUN ./setup.sh

VOLUME [ "/vscode", "/home/${USER}" ]

EXPOSE 8000

# Set working directory
WORKDIR /app

# Default command (can be changed as needed)
ENTRYPOINT [ "./start.sh" ]