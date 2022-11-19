# ==============================================================================
# Add https://gitlab.com/pipeline-components/org/base-entrypoint
# ------------------------------------------------------------------------------
FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

# ==============================================================================
# Build process
# ------------------------------------------------------------------------------
FROM python:3.11.0-alpine3.16 as build
ENV PYTHONUSERBASE /app
ENV PATH "$PATH:/app/bin/"

WORKDIR /app/
COPY app /app/

# Adding dependencies
# hadolint ignore=DL3018
RUN \
    apk add --no-cache build-base && \
# hadolint ignore=DL3013
    pip3 install --user --no-cache-dir --prefer-binary -r requirements.txt

# ==============================================================================
# Component specific
# ------------------------------------------------------------------------------
FROM python:3.11.0-alpine3.16

ENV PATH "$PATH:/app/bin/"
ENV PYTHONUSERBASE /app
COPY --from=build /app /app

# ==============================================================================
# Generic for all components
# ------------------------------------------------------------------------------
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD black

WORKDIR /code/

# ==============================================================================
# Container meta information
# ------------------------------------------------------------------------------
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Black in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Black" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/black/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/black/" \
    org.label-schema.vendor="Pipeline Components"
