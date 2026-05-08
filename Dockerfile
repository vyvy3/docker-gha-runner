FROM --platform=$TARGETPLATFORM ubuntu:22.04

ARG TARGETARCH
ARG OS=linux
ARG VERSION=2.328.0

RUN apt update && apt install -y curl wget sudo git jq ca-certificates gnupg lsb-release

RUN useradd -G sudo -ms /bin/bash github && \
    install -o github -g github -m 0755 -d /home/github/actions && \
    echo 'github ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/github

USER github
WORKDIR /home/github/actions

RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        curl -o actions-runner-${OS}.tar.gz -fsSL https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-${OS}-x64-${VERSION}.tar.gz ; \
    fi ; \
    if [ "${TARGETARCH}" = "arm64" ]; then \
        curl -o actions-runner-${OS}.tar.gz -fsSL https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-${OS}-arm64-${VERSION}.tar.gz ; \
    fi ; \
    tar xzf ./actions-runner-${OS}.tar.gz && \
    rm -f actions-runner-${OS}.tar.gz

COPY ./start.sh ./start.sh

USER root

RUN ./bin/installdependencies.sh && \
    chmod +x ./start.sh

USER github

CMD ["./start.sh"]
