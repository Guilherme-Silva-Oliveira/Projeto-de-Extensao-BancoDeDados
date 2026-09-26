FROM mysql:8.0.26
ARG SCRIPT
COPY ./scripts/${SCRIPT} /docker-entrypoint-initdb.d/
