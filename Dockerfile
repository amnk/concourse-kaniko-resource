FROM gcr.io/kaniko-project/executor:latest

# Setup kaniko in the alpine image
FROM python:3-alpine
COPY --from=0 /kaniko /kaniko
ENV PATH "/kaniko:${PATH}"
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json
RUN ["docker-credential-gcr", "config", "--token-source=env"]

RUN mkdir -p /opt/resource

COPY assets/* /opt/resource/

RUN python -m pip install --upgrade pip
RUN pip3 install -r /opt/resource/requirements.txt

ENTRYPOINT [ "/bin/sh" ]