FROM python:3.9.6-alpine3.14

RUN apk update
RUN apk add  libc6-compat

RUN apk add --no-cache --upgrade ca-certificates bash curl wget gettext jq bind-tools \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v1.21.2/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config

WORKDIR /usr/src/app

COPY access_token/get_access_token.sh ./
COPY partition_init/data_init.sh ./
COPY partition_init/partition_init_api_payload.json ./

RUN chmod +x ./get_access_token.sh
RUN chmod +x ./data_init.sh
ENTRYPOINT [ "./data_init.sh" ]