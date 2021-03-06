FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM python:3.8.3-alpine3.10
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD black

WORKDIR /app/

# Generic
COPY app /app/

# Python
RUN apk --no-cache add --virtual .build \
    build-base=0.5-r1 \
	 && \
    pip install --no-cache-dir -r requirements.txt \
	 && \
    apk --no-cache del .build

WORKDIR /code/

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Black in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Black" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/black/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/black/" \
    org.label-schema.vendor="Pipeline Components"
