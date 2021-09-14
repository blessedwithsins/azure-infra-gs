FROM mcr.microsoft.com/azure-cli:2.15.1

RUN apk update
RUN apk add ca-certificates wget && update-ca-certificates
RUN apk add  libc6-compat

RUN apk add ca-certificates bash curl wget gettext jq bind-tools \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v1.21.2/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install --no-cache --upgrade azure-cosmos

WORKDIR /usr/src/app

COPY data_seeding_agent/seed_data.sh ./
COPY test_data/Legal_COO.json ./test_data/
COPY test_data/tenant_info_1.json ./test_data/
COPY test_data/tenant_info_2.json ./test_data/
COPY data_seeding_agent/upload-data.py ./test_data/

RUN chmod +x ./seed_data.sh
ENTRYPOINT [ "./seed_data.sh" ]