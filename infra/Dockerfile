ARG STEP_1_IMAGE=community.opengroup.org:5555/osdu/platform/deployment-and-operations/base-containers-azure/alpine-terraform:0.0.2
ARG IMAGE_TAG=0.0.1

FROM ${STEP_1_IMAGE} AS STEP_1

ENV PATH="~/:${PATH}"

COPY scripts/terraform.sh terraform.sh
COPY modules modules
USER terraform

COPY --chown=terraform:terraform templates templates
WORKDIR /home/terraform/templates

ENTRYPOINT ["/usr/bin/terraform"]

CMD ["--help"]

