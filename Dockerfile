FROM gcr.io/kaniko-project/executor:latest

# Setup kaniko in the alpine image
FROM alpine:latest
COPY --from=0 /kaniko /kaniko
ENV HOME /root
ENV USER /root
ENV PATH "/kaniko:${PATH}"
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json
RUN ["docker-credential-gcr", "config", "--token-source=env"]

RUN mkdir -p /opt/resource

#Install python
WORKDIR /opt/resource

RUN apk add --no-cache --update \
    git \
    bash \
    libffi-dev \
    openssl-dev \
    bzip2-dev \
    zlib-dev \
    readline-dev \
    sqlite-dev \
    build-base \
    linux-headers 

# Set Python version
ARG PYTHON_VERSION='3.7.0'
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pip install --upgrade pip && pyenv rehash

# Clean pip cache
RUN rm -rf ~/.cache/pip

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

COPY assets assets
COPY test test

RUN pip install -r assets/requirements.txt

ENTRYPOINT [ "/bin/sh" ]

#https://docs.gitlab.com/ce/ci/docker/using_kaniko.html#building-a-docker-image-with-kaniko