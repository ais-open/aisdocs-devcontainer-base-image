# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.234.0/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
ARG DOCFX_VERSION="2.56.7"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# ** [Optional] Uncomment this section to install additional packages. **
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends git-lfs

RUN apt install apt-transport-https dirmngr gnupg ca-certificates -y \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/debian stable-buster main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt update \
    && apt install mono-devel -y

ARG DOCFX_VERSION
RUN wget https://github.com/dotnet/docfx/releases/download/v$DOCFX_VERSION/docfx.zip \
    && unzip docfx.zip -d docfx.$DOCFX_VERSION \
    && rm docfx.zip

ARG DOCFX_VERSION
RUN cp -r /docfx.$DOCFX_VERSION /usr/local/bin/docfx.$DOCFX_VERSION

ARG DOCFX_VERSION
RUN rm -rf /docfx.$DOCFX_VERSION

COPY docfx /usr/local/bin/docfx

RUN chmod 777 /usr/local/bin/docfx